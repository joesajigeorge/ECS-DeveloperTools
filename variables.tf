variable projectname {
  type        = string
  default     = "MyProject123"
  description = "The name of the project"
}

variable env {
  type        = string
  default     = "dev"
  description = "The name of the environment"
}

variable awsprofile {
  type        = string
  default     = "myaccount"
  description = "AWS profile configured in the system"
}

variable region {
  type        = string
  default     = "us-east-1"
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

variable "ami_version" {
  default = "*"
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

variable "pipeline_artifact_bucket_name" {
    description = "Name of the pipeline artifact S3 bucket"
}

variable "github_oauth_token" {
    description = "Github oauth token"
}

variable "repo_branch" {
    description = "Repository branch"
}

variable "poll_source_changes" {
    description = "Poll source changes"
}

variable "code_start_connection_arn" {
    description = "Code start connection arn"
}

variable "repo_id" {
    description = "Repository id"
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