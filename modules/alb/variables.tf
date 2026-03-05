variable "vpc_id" {}
variable "public_subnet_ids" {}
variable "alb_sg_id" {}
variable "app_port" {}
variable "tags" {}
variable "enable_waf" {
  type    = bool
  default = false
}

variable "waf_acl_arn" {
  type    = string
  default = null
}