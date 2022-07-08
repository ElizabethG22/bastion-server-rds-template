variable "region_aws" {
  default = "eu-west-1"
}

variable "prefix" {
  default = "yourname"
}

variable "contact" {
  default = "firstname.lastname@sainsburys.co.uk"
}

variable "db_username" {
  description = "Username for the RDS postgres instance"
}

variable "db_password" {
  description = "Password for the RDS postgres instance"
}

variable "db_name" {
  description = "Database name for the RDS postgres instance"
}
