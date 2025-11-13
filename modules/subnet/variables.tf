variable "vpc_id" {
  type        = string
  description = "VPC ID to attach the subnet"
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for the subnet"
}

variable "availability_zone" {
  type        = string
  description = "AWS availability zone"
}

variable "tags" {
  type    = map(string)
  default = {}
}

