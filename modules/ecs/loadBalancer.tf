resource "aws_security_group" "lb_sg" {
  name        = "${var.projectname}-${var.env}-alb-sg"
  description = "Container Instance Allowed Ports"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_lb" "alb" {
  name               = "${var.projectname}-${var.env}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  # subnets            = data.aws_subnet.public_subnet.*.id
  subnets            = var.public_subnet

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "lb-http-target" {
  depends_on = [ aws_lb.alb ]
  name     = "${var.projectname}-${var.env}-http-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    interval            = 25
    path                = "/health"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = 200
  }
}

resource "aws_alb_listener" "alb_listener" {  
  depends_on        = [ aws_lb.alb, aws_lb_target_group.lb-http-target ]
  load_balancer_arn = aws_lb.alb.arn
  port              = "80" 
  protocol          = "HTTP"
  
  default_action {    
    target_group_arn = aws_lb_target_group.lb-http-target.arn
    type             = "forward"  
  }
}