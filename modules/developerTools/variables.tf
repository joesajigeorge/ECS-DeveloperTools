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

variable ecs-task-execution-role {
    description = "ARN of ECS task execution role"
}

variable ecs_role {
    description = "ARN of ECS execution role"
}

variable aws_lb_target_group_name {
    description = "Name of load balancer target group"
}

variable aws_ecs_cluster_name {
  description = "ECS cluster name"
}

variable aws_ecs_service_name {
  description = "ECS service name"
}

variable aws_alb_listener_arn {
  description = "Load balancer listeaner arn"
}