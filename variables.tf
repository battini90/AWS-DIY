variable "access_key" {}
variable "secret_key" {}
variable "region" {
    default = "us-east-1"
}
###Default availZones:

variable "availZones" {
    type = "list"
    default= ["us-east-1a","us-east-1b","us-east-1c"]
}

############################
##Network vars:

variable "vpcCider" {
     default = "10.0.0.0/16"
}

variable "publicCiders" {
    type = "list"
    default = ["10.0.0.0/24", "10.0.1.0/24","10.0.2.0/24"]
}

variable "appCiders" {
    type = "list"
    default = ["10.0.10.0/24","10.0.11.0/24","10.0.12.0/24"]
}

variable "databaseCiders"{
    type = "list"
    default =["10.0.20.0/24","10.0.21.0/24","10.0.22.0/24"]
}

