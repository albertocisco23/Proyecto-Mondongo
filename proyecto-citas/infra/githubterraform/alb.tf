resource "aws_lb" "app_alb" {
  name               = "citas-alb"
  load_balancer_type = "application"
  internal           = false

  subnets         = module.vpc.public_subnets
  security_groups = [aws_security_group.alb_sg.id]
}

##################################
# LISTENER HTTP
##################################

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Service not ready"
      status_code  = "200"
    }
  }
}
