resource "aws_ecs_cluster" "main" {
  name = "${var.projectname}-${var.env}"
  capacity_providers = [ aws_ecs_capacity_provider.cap_provider.name ]
}