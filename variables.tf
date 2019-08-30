variable "environment" {
  type        = "string"
  description = "The environment this stack belongs to"
}

variable "vpc_id" {
  type        = "string"
  description = "The ID of the VPC this stack belongs to"
}

variable "subnet_id" {
  type        = "string"
  description = "The ID of the subnet this stack belongs to"
}

variable "oebs_app_profile" {
  type        = "string"
  description = "The IAM role of EC2 Oracle Application Server"
}
