resource "aws_ecs_service" "service" {
  depends_on      = [ 
      aws_ecs_cluster.main, 
      aws_ecs_task_definition.task, 
      aws_lb.alb, 
      aws_lb_target_group.lb-http-target,
      aws_ecs_capacity_provider.cap_provider ]
  name            = "${var.projectname}-${var.env}-service"
  cluster         = aws_ecs_cluster.main.id


  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.cap_provider.name
    weight            = 1
    base              = 0
  }

  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1
  iam_role        = aws_iam_role.ecs-service-role.arn

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.lb-http-target.arn
    container_name   = "api"
    container_port   = var.container_port
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-east-1a, us-east-1b]"
  }
}

resource "aws_appautoscaling_target" "main" {
  depends_on         = [ aws_ecs_service.service ]
  service_namespace  = "ecs"
  resource_id        = "service/${var.projectname}-${var.env}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = "1"
  max_capacity       = "3"
}

resource "aws_appautoscaling_policy" "up" {
  depends_on = [ aws_appautoscaling_target.main ]
  name               = "${var.projectname}-${var.env}-ScaleUp"
  service_namespace  = "ecs"
  resource_id        = "service/${var.projectname}-${var.env}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = "60"
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}

resource "aws_appautoscaling_policy" "down" {
  depends_on = [ aws_appautoscaling_target.main ]
  name               = "${var.projectname}-${var.env}-ScaleDown"
  service_namespace  = "ecs"
  resource_id        = "service/${var.projectname}-${var.env}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = "60"
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}