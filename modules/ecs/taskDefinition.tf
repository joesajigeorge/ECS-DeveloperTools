resource "aws_ecs_task_definition" "task" {
  depends_on            = [ aws_ecs_cluster.main, aws_iam_role.ecs-task-execution-role ]
  family                = "${var.projectname}-${var.env}-task-def"
  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.ecr_image_uri
      cpu       = var.container_cpu
      memory    = var.container_memory
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.host_port
        }
      ]
    }
  ])
  # network_mode          = "bridge"
  execution_role_arn    = aws_iam_role.ecs-task-execution-role.arn

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-east-1a, us-east-1b]"
  }
}