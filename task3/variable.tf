variable "region" {
  default = "us"
}

variable "azs" {
  default = ["west-1a", "west-1b", "west-1c"]
}


variable "environment" {
   default = ["production", "development"]
}

variable "os" {
  default = ["windows", "linux"]
}
