resource "aws_lb" "default" {
  name            = "example-lb"
  subnets         = [aws_subnet.public-sub-1.id, aws_subnet.public-sub-2.id]
  security_groups = [aws_security_group.lb.id]
}

resource "aws_lb_target_group" "timitech" {
  name        = "example-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.test-vpc.id
  target_type = "ip"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    path                = "/"
  }
}

#redirecting all incoming traffic from ALB to the target group
resource "aws_lb_listener" "timitech" {
  load_balancer_arn = aws_lb.default.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.timitech.id
    type             = "forward"
  }
}