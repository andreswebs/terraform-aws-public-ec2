# terraform-aws-public-ec2

Creates a public EC2 instance using the latest Ubuntu 22.04 AMI.

**Warning:** This module is for testing purposes only. Do **NOT** use it in
production!

[//]: # (BEGIN_TF_DOCS)


## Usage

Example:

```hcl
module "instance" {
  source         = "github.com/andreswebs/terraform-aws-public-ec2"
  name           = var.name
  subnet_id      = var.subnet_id
  ebs_volumes    = var.ebs_volumes
  cidr_whitelist = var.cidr_whitelist
}
```



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | n/a | `string` | `null` | no |
| <a name="input_cidr_whitelist"></a> [cidr\_whitelist](#input\_cidr\_whitelist) | n/a | `list(string)` | n/a | yes |
| <a name="input_ebs_volumes"></a> [ebs\_volumes](#input\_ebs\_volumes) | n/a | <pre>list(object({<br>    name           = optional(string)<br>    device_name    = string<br>    size           = number<br>    type           = optional(string, "gp3")<br>    encrypted      = optional(bool, true)<br>    final_snapshot = optional(bool, false)<br>    snapshot_id    = optional(string)<br>    mount_path     = string<br>  }))</pre> | n/a | yes |
| <a name="input_enclave_enabled"></a> [enclave\_enabled](#input\_enclave\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_instance_termination_disable"></a> [instance\_termination\_disable](#input\_instance\_termination\_disable) | n/a | `bool` | `false` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | n/a | `string` | `"t3a.medium"` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | n/a | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_root_volume_delete"></a> [root\_volume\_delete](#input\_root\_volume\_delete) | n/a | `bool` | `true` | no |
| <a name="input_root_volume_encrypted"></a> [root\_volume\_encrypted](#input\_root\_volume\_encrypted) | n/a | `bool` | `true` | no |
| <a name="input_root_volume_size"></a> [root\_volume\_size](#input\_root\_volume\_size) | n/a | `number` | `0` | no |
| <a name="input_ssh_key_name"></a> [ssh\_key\_name](#input\_ssh\_key\_name) | n/a | `string` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | n/a | `string` | n/a | yes |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2_keypair"></a> [ec2\_keypair](#module\_ec2\_keypair) | andreswebs/insecure-ec2-key-pair/aws | 1.0.0 |
| <a name="module_ec2_role"></a> [ec2\_role](#module\_ec2\_role) | andreswebs/ec2-role/aws | 1.0.0 |
| <a name="module_s3_requisites_for_ssm"></a> [s3\_requisites\_for\_ssm](#module\_s3\_requisites\_for\_ssm) | andreswebs/s3-requisites-for-ssm-policy-document/aws | 1.0.0 |
| <a name="module_ubuntu_22_04_latest"></a> [ubuntu\_22\_04\_latest](#module\_ubuntu\_22\_04\_latest) | andreswebs/ami-ubuntu/aws | 2.0.0 |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance"></a> [instance](#output\_instance) | n/a |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | n/a |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |
| <a name="provider_cloudinit"></a> [cloudinit](#provider\_cloudinit) | n/a |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_eip.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_role_policy.s3_requisites_for_ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [cloudinit_config.this](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config) | data source |

[//]: # (END_TF_DOCS)

## Authors

**Andre Silva** - [@andreswebs](https://github.com/andreswebs)

## License

This project is licensed under the [Unlicense](UNLICENSE.md).
