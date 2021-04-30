variable projectname {
  type        = string
  description = "The name of the project"
}

variable env {
  type        = string
  description = "The name of the environment"
}

variable region {
  type        = string
  description = "The AWS region"
}

variable vpc_cidr {
  type        = string
  description = "The VPC CIDR block"
}

variable "public_subnet" {
  type = list
  description = "Public Subnet configurations"
}

variable "private_subnet" {
  type = list
  description = "Private Subnet configurations"
}