variable "region" {
  type = string
  default = "us"
}

variable "azs" {
  type = list(string)
  default = ["west-1a", "west-1b", "west-1c"]
}


variable "environment" {
   type = list(string)
   default = ["production","development"]
}

variable "os" {
  type = list(string)
  default = ["windows","linux"]
}

locals {
  
  
  varenvironment = [for environment in var.environment : substr(environment, 0, 1)]                        #output will be ["p","d"]
  varos          = [for os in var.os : substr(os, 0, 1)]                                                   #output will be ["w","l"]
  varazs1        = element([for azs in var.azs : element(split("", element(split("-", azs), 0)), 0)], 0)   #output will be "w"
  varazs2        = [for azs in var.azs : element(split("-", azs), 1)]                                      #output will be "["1a","1b","1c"]"
  
  varsetproduct  = setproduct(local.varazs2, local.varenvironment, local.varos)
  varcombination = [for x in local.varsetproduct : "${var.region}${local.varazs1}${x[0]}${x[1]}${x[2]}"]

}