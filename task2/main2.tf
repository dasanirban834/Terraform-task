######  Write a script to create naming convention in that format <region> <aAZ> <environemnt> <os> <serial-no> <drive-mount> <disk>    #######


locals {
  environment = substr (var.environment, 0, 1)                                      # output will be "p"
  os          = substr (var.os, 0, 1)                                               # output will be "w"
  region      = substr (var.region, 0, 2)                                           # output will be "us"
  zone1       = substr (element(split ("-", var.zone), 1), 0, 1)                    # output will be "w"
  zone2       = element(split ("", (element(split ("-", var.zone), 1))), 4)         # output will be "1"
  zone3       = element(split("-", var.zone), 2)                                    # output will be "a"
  zone        = "${local.zone1}${local.zone2}${local.zone3}"                        # output will be "w1a"
  serial-no   = var.serial-no                                                       
  drive-mount = var.drive-mount
  disk        = var.disk

  syntax      = "${local.region}${local.zone}${local.environment}${local.os}${local.serial-no}-${local.drive-mount}-${local.disk}"
}