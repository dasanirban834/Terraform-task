######## Write a script of creating combination of naming convention in that format [ <region> <availability-zone> <environment> <os> ]########


locals {
  
  varenvironment = [for environment in var.environment : substr(environment, 0, 1)]                        #output will be ["p","d"]
  varos          = [for os in var.os : substr(os, 0, 1)]                                                   #output will be ["w","l"]
  varazs1        = element([for azs in var.azs : element(split("", element(split("-", azs), 0)), 0)], 0)   #output will be "w"
  varazs2        = [for azs in var.azs : element(split("-", azs), 1)]                                      #output will be "["1a","1b","1c"]"
  
  varsetproduct  = setproduct(local.varazs2, local.varenvironment, local.varos)
  varcombination = [for x in local.varsetproduct : "${var.region}${local.varazs1}${x[0]}${x[1]}${x[2]}"]
  

}

