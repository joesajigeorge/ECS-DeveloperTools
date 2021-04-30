# output ecr_url {
#   value       = aws_ecr_repository.repo.repository_url
#   description = "The ECR repository URL"
# }

output ecs-task-execution-role {
  value       = aws_iam_role.ecs-task-execution-role.arn
  description = "ARN of ECS task execution role"
}

output ecs_role {
  value       = aws_iam_role.ecs_role.arn
  description = "ARN of ECS execution role"
}

output aws_lb_target_group_name {
  value       = aws_lb_target_group.lb-http-target.name
  description = "Name of load balancer target group"
}

output aws_ecs_cluster_name {
  value       = aws_ecs_cluster.main.name
  description = "ECS cluster name"
}

output aws_ecs_service_name {
  value       = aws_ecs_service.service.name
  description = "ECS service name"
}

output aws_alb_listener_arn {
  value       = aws_alb_listener.alb_listener.arn
  description = "Load balancer listeaner arn"
}