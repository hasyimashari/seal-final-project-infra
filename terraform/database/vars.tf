variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

variable "private_sub_ids" {
  type = list(string)
}

variable "db_security_group" {
  type = list(string)
}