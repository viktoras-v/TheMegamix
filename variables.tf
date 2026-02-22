variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "az" {
  type    = string
  default = "eu-central-1a"
}

#variable "ami_id" {
#  type = string
#}

#variable "subnet_ids" {
#  type = list(string)
#  default = [
#  "subnet-aaa",
#  "subnet-bbb"
#]
#}

variable "cidr_block" {
  type = list(string)
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type = list(string)
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  type = list(string)
  default = "10.0.10.0/24"
}

variable "my_ip" {
  type = list(string)
  default = "0.0.0.0/0"
}

#variable "azs" {
#  type = list(string)
#}


