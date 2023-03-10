#ALB Security group
resource "aws_security_group" "lb" {
  name        = "example-alb-security-group"
  description = "controls access to the ALB"
  vpc_id      = aws_vpc.test-vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Namw = "allow_tls"
  }
}


#This security group for ecs - Traffic to the ecs cluster should come from the ALB
resource "aws_security_group" "ecs_sg" {
  name        = "ecs-task-security-group"
  description = "allow inbound access from the ALB only"
  vpc_id      = aws_vpc.test-vpc.id

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}