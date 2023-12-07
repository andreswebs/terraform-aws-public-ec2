module "instance" {
  source         = "github.com/andreswebs/terraform-aws-public-ec2"
  name           = var.name
  subnet_id      = var.subnet_id
  ebs_volumes    = var.ebs_volumes
  cidr_whitelist = var.cidr_whitelist
}