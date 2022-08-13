
resource "aws_security_group" "lb_sg" {
  name = "loadbalancer_sg"
  description = "allows access to the load balancer"
  vpc_id = aws_vpc.main.id
  ingress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "bastion_sg" {
  name = "bastion_host_sg"
  description = "allows ssh access to the bastion host"
  vpc_id = aws_vpc.main.id
  ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app_sg" {
  name = "application_sg"
  description = "allows load balancer and bastion to access to the application"
  vpc_id = aws_vpc.main.id
  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "http_rule" {
  type = "ingress"
  protocol = "tcp"
  from_port = 80
  to_port = 80
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.app_sg.id
}
resource "aws_security_group_rule" "ssh_rule" {
  type = "ingress"
  protocol = "tcp"
  from_port = 22
  to_port = 22
  security_group_id = aws_security_group.app_sg.id
  source_security_group_id = aws_security_group.bastion_sg.id
}