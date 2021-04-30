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

variable "ami_version" {
  description = "The ECS AMI version"
}

variable "instance_type" {
  description = "AWS Instance type, if you change, make sure it is compatible with AMI, not all AMIs allow all instance types "
}

variable "asg_desired" {
  description = "Desired number of ECS servers to run."
}

variable "asg_min" {
  description = "Minimum number of ECS servers to run."
}

variable "asg_max" {
  description = "Maximum number of ECS servers to run."
}

variable vpc_id {
  description = "The VPC Id from VPC module"
}

variable public_subnet {
  description = "The Public subnets from VPC module"
}

variable private_subnet {
  description = "The Private subnets from VPC module"
}

variable "ecr_image_uri" {
    description = "ECR image URI"
}

variable "container_name" {
    description = "ECS container name"
}

variable "container_cpu" {
    description = "ECS container CPU"
}

variable "container_memory" {
    description = "ECS container Memory"
}

variable "container_port" {
    description = "ECS container port"
}

variable "host_port" {
    description = "ECS host port"
}

variable "key_pair" {
    description = "Key pair name"
}