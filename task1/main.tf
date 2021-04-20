 locals {
  
  environment = substr(var.environment, 0, 1)
  os          = substr(var.os, 0, 1)
  region      = substr (var.region, 0, 2)
  zone1       = substr (element(split ("-", var.zone), 0), 0, 1)
  zone2       = element(split ("", (element(split ("-", var.zone), 0))), 4)
  zone3       = element(split("-", var.zone), 1)

  zone        = "${local.zone1}${local.zone2}${local.zone3}"

  syntax      = "${local.region}${local.zone}${local.environment}${local.os}"

  
  }
