module "ubuntu_22_04_latest" {
  source  = "andreswebs/ami-ubuntu/aws"
  version = "2.0.0"
}

locals {
  ssh_key_name     = var.ssh_key_name != "" && var.ssh_key_name != null ? var.ssh_key_name : "${var.name}-ssh"
  default_ami_id   = module.ubuntu_22_04_latest.ami_id
  ami_id           = var.ami_id != "" && var.ami_id != null ? var.ami_id : local.default_ami_id
  root_volume_size = var.root_volume_size == 0 ? null : var.root_volume_size
}

data "aws_subnet" "this" {
  id = var.subnet_id
}

locals {
  subnet = data.aws_subnet.this
}

resource "aws_security_group" "this" {
  vpc_id = local.subnet.vpc_id

  revoke_rules_on_delete = true

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.cidr_whitelist
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.name}-sg"
  }
}

module "ec2_keypair" {
  source             = "andreswebs/insecure-ec2-key-pair/aws"
  version            = "1.0.0"
  key_name           = local.ssh_key_name
  ssm_parameter_name = "/${var.name}/ssh-key"
}

module "ec2_role" {
  source       = "andreswebs/ec2-role/aws"
  version      = "1.0.0"
  role_name    = var.name
  profile_name = var.name
  policies = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonSSMDirectoryServiceAccess"
  ]
}

module "s3_requisites_for_ssm" {
  source  = "andreswebs/s3-requisites-for-ssm-policy-document/aws"
  version = "1.0.0"
}

resource "aws_iam_role_policy" "s3_requisites_for_ssm" {
  name   = "s3-requisites-for-ssm"
  role   = module.ec2_role.role.name
  policy = module.s3_requisites_for_ssm.json
}

data "cloudinit_config" "this" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/tpl/cloudinit.yaml.tftpl", {
      user    = "ubuntu"
      group   = "ubuntu"
      volumes = var.ebs_volumes
    })
  }
}

resource "aws_instance" "this" {
  ami                     = local.ami_id
  disable_api_termination = var.instance_termination_disable
  key_name                = local.ssh_key_name
  vpc_security_group_ids  = [aws_security_group.this.id]
  subnet_id               = local.subnet.id
  iam_instance_profile    = module.ec2_role.instance_profile.name
  instance_type           = var.instance_type

  root_block_device {
    delete_on_termination = var.root_volume_delete
    encrypted             = var.root_volume_encrypted
    volume_size           = local.root_volume_size
    kms_key_id            = var.kms_key_id
  }

  user_data_base64 = data.cloudinit_config.this.rendered

  enclave_options {
    enabled = var.enclave_enabled
  }

  tags = {
    Name = var.name
  }

  lifecycle {
    ignore_changes = [ami, tags]
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  dynamic "ebs_block_device" {
    for_each = toset(var.ebs_volumes)
    iterator = volume
    content {
      device_name = volume.value.device_name
      volume_type = volume.value.type
      volume_size = volume.value.size
      snapshot_id = volume.value.snapshot_id
      encrypted   = volume.value.encrypted
      kms_key_id  = var.kms_key_id

      delete_on_termination = true

      tags = {
        Name = volume.value.name
      }
    }
  }

}

resource "aws_eip" "this" {
  domain   = "vpc"
  instance = aws_instance.this.id
}
