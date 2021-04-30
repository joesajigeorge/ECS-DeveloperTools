resource "aws_ecs_capacity_provider" "cap_provider" {
  depends_on = [ aws_autoscaling_group.ecs ]
  name = "${var.projectname}-${var.env}-cap"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs.arn
    managed_termination_protection = "DISABLED"
  }
}