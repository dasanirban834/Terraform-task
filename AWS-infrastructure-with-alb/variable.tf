#####################################################
# VPC Requirement
#####################################################
variable "custom_vpc" {
  description = "VPC for testing environment"
  type        = string
  default     = "10.0.0.0/16"
}

#####################################################
# EC2 Requirement
#####################################################
variable "instance_tenancy" {
  description = "it defines the tenancy of VPC. Whether it's defsult or dedicated"
  type        = string
  default     = "default"
}

variable "ami_id" {
  description = "ami id"
  type        = string
  default     = "ami-087c17d1fe0178315"
}

variable "instance_type" {
  description = "Instance type to create an instance"
  type        = string
  default     = "t2.micro"
}

variable "pvt_key_path" {
  description = "Private key of EC2 instances"
  type        = string
  default     = "~/.ssh/id_rsa"
}

variable "pub_key_path" {
  description = "Public key of EC2 instances"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

