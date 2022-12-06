variable "ami_name" {
  type    = string
  default = "rhel-8"
}

variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "instance_type" {
  type    = string
  default = "t3.small"
}

variable "allowed_account_ids" {
  type        = list(string)
  description = "Comma separated list of AWS account Ids you wish to share the resulting AMI with.  Note: Cannot be empty"
  default     = [""]
}

variable "run_test_build" {
  type        = bool
  description = "Set to true if you just want to test the build process and NOT create an AMI at the end."

  default = false
}

#variable "kms_key_arn" {
#  type = string
#  default = ""
#}
#
#variable "encrypt" {
#  type = bool
#  description = "Whether to encrypt the resulting AMI block device. Requires ${var.kms_key_arn} to be set as you cannot use default account KMS key to encrypt AMIs"
#
#  default = true
#}
