data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-${var.ami_version}-amazon-ecs-optimized"]
  }
}

resource "aws_security_group" "ecs" {
  name        = "${var.projectname}-${var.env}-ecs-sg"
  description = "Container Instance Allowed Ports"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    security_groups = [ aws_security_group.lb_sg.id ]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    security_groups = [ aws_security_group.lb_sg.id ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "ecs" {
  depends_on                  = [ aws_security_group.ecs ]
  name                        = "${var.projectname}-${var.env}-launch-config"
  image_id                    =  data.aws_ami.ecs_ami.id
  instance_type               = var.instance_type
  key_name                    = var.key_pair
  iam_instance_profile        = aws_iam_instance_profile.ecs_profile.name
  security_groups             = [ aws_security_group.ecs.id ]

  ebs_block_device {
    device_name           = "/dev/xvdcz"
    volume_size           = "22"
    volume_type           = "gp2"
    delete_on_termination = true
  }

  user_data = <<EOF
  #!/bin/bash
  echo ECS_CLUSTER=${var.projectname}-${var.env} >> /etc/ecs/ecs.config;echo ECS_BACKEND_HOST= >> /etc/ecs/ecs.config;
  EOF

  lifecycle {
    create_before_destroy = true
  }
}

