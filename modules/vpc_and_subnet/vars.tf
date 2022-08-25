
variable "environment" {
  description = "Deployment Environment"
}

variable "vpc_cidr" {
  description = "CIDR block of the vpc"
}

variable "private_subnets_cidr" {
  type        = list
  description = "CIDR block for Private Subnet"
}

variable "public_subnets_cidr" {
  type        = list
  description = "CIDR block for Private Subnet"
}

 


