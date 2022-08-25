variable "AWS_ACCESS_KEY" {
  type = string
}
variable "AWS_SECRET_KEY" {
  type = string
}
variable "APP_HTTP_RESPONSE" {
  type = number
}
variable "APP_PORT" {
  type = number
}
variable "AWS_REGION" {
  type = string
}

variable "environment" {
  type        = string
  description = "Deployment Environment"
  default     = "qbe"
}

variable "bean_env_name" {
  description = "Beanstalk environment name"
  default     = "qbe-bean"
}

variable "vpc_cidr" {
  description = "CIDR block of the vpc"
  default     = "10.0.0.0/16"
}

variable "private_subnets_cidr" {
  type        = list(any)
  description = "CIDR block for Private Subnet"
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "public_subnets_cidr" {
  type        = list(any)
  description = "CIDR block for Private Subnet"
  default     = ["10.0.20.0/24"]
}

variable "ec2_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}




