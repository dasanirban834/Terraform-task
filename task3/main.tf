locals {
  
  var1-environment = [for environment in var.environment : substr(environment, 0, 1)]
  var2-os          = [for os in var.os : substr(os, 0, 1)]
  
  
  var3-azs1        = element([for azs in var.azs : element(split("", element(split("-", azs), 0)), 0)], 0)
  var3-azs2        = [for azs in var.azs : element(split("-", azs), 1)]

  var              = setproduct(local.var3-azs2, local.var1-environment, local.var2-os)
    
}

