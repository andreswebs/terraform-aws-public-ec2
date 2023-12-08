variable "name" {
  type = string
}

variable "root_volume_delete" {
  type    = bool
  default = true
}

variable "root_volume_encrypted" {
  type    = bool
  default = true
}

variable "root_volume_type" {
  type    = string
  default = "gp3"
}

variable "root_volume_size" {
  type    = number
  default = 0
}

variable "instance_type" {
  type    = string
  default = "t3a.medium"
}

variable "instance_termination_disable" {
  type    = bool
  default = false
}

variable "subnet_id" {
  type = string
}

variable "ssh_key_name" {
  type    = string
  default = null
}

variable "ami_id" {
  type    = string
  default = null
}

variable "cidr_whitelist" {
  type = list(string)
}

variable "enclave_enabled" {
  type    = bool
  default = false
}

variable "kms_key_id" {
  type    = string
  default = null
}

variable "ebs_volumes" {
  type = list(object({
    name           = optional(string)
    device_name    = string
    size           = number
    type           = optional(string, "gp3")
    encrypted      = optional(bool, true)
    final_snapshot = optional(bool, false)
    snapshot_id    = optional(string)
    mount_path     = string
    uid            = optional(number, 1000)
    gid            = optional(number, 1000)
  }))
}

variable "user_data_replace_on_change" {
  type = bool
  default = true
}