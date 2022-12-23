resource "aws_db_instance" "MySQL" {
  allocated_storage    = 20
  db_subnet_group_name = aws_db_subnet_group.SQL_group.name
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = "db_username"
  password             = "db_password"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true

}


#RDS subnet group
resource "aws_db_subnet_group" "SQL_group" {
  name       = "mysql_rds"
  subnet_ids = [aws_subnet.private-sub-1.id, aws_subnet.private-sub-2.id]

  tags = {
    Name = "My DB subnet group"
  }
}

#RDS security group
resource "aws_security_group" "mysql_sg" {
  name        = "mysql-secgroup"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.test-vpc.id

  ingress {
    description = "TLS from MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}