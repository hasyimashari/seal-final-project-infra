variable "vpc_id" {
  type = string
}

variable "ec2_target_id" {
  type = string
}

variable "alb_sg_id" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}