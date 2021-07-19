variable "resource_group_name" {
  type    = string
  default = "resource-group-lab"
}

variable "resource_group_location" {
  type    = string
  default = "westus2"
}

variable "tags" {
  type = map(any)
  default = {
    "environemnt" = "test"
  }
}

variable "vnet_address" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "vnet_subnet_address" {
  type    = list(string)
  default = ["10.0.1.0/24"]
}

variable "availability_zones" {
  type    = list(string)
  default = ["1", "2", "3"]
}