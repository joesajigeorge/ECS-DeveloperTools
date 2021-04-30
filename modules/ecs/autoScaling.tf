resource "aws_autoscaling_group" "ecs" {
  depends_on           = [ aws_launch_configuration.ecs ]
  name_prefix          = "${var.projectname}-${var.env}-asg"
  # vpc_zone_identifier  = data.aws_subnet.private_subnet.*.id
  vpc_zone_identifier  = var.private_subnet
  launch_configuration = aws_launch_configuration.ecs.name
  min_size             = var.asg_min
  max_size             = var.asg_max
  desired_capacity     = var.asg_desired
  termination_policies = ["OldestLaunchConfiguration", "Default"]
  protect_from_scale_in = false

  tags = [{
    key                 = "Name"
    value               = "${var.projectname}-${var.env}-asg"
    propagate_at_launch = true
  }]

  lifecycle {
    create_before_destroy = true
  }
}