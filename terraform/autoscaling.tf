
resource "aws_launch_configuration" "ubuntu_lt" {
  name = "ubuntu_http_server"
  image_id = var.ami["ubuntu"]
  instance_type = var.instance_type["ubuntu"]
  key_name = var.key_pairs.app
  security_groups = [aws_security_group.app_sg.id]
  user_data = file("apache.tpl")
}
resource "aws_lb_target_group" "http_target" {
  name = "http"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.main.id
  health_check {
    enabled = true
    interval = 10
    path = "/"
    protocol = "HTTP"
    timeout = 8
    unhealthy_threshold = 2
  }
}
resource "aws_autoscaling_group" "app_as" {
  launch_configuration = aws_launch_configuration.ubuntu_lt.name
  min_size = 4
  max_size = 6
  vpc_zone_identifier = [ aws_subnet.priv0.id, aws_subnet.priv1.id ]
  target_group_arns = [aws_lb_target_group.http_target.arn]
}
resource "aws_lb" "app_lb" {
  name = "highly-available-app"
  load_balancer_type = "application"
  security_groups = [aws_security_group.lb_sg.id]
  subnets = [aws_subnet.pub0.id,aws_subnet.pub1.id]
  ip_address_type = "ipv4"
}
resource "aws_lb_listener" "http_l" {
  protocol = "HTTP"
  port = 80
  load_balancer_arn = aws_lb.app_lb.arn
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.http_target.arn
  }
}
resource "aws_lb_listener_rule" "http_lr" {
  listener_arn = aws_lb_listener.http_l.arn
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.http_target.arn
  }
  condition {
    path_pattern{
      values = ["/"]
    }
  }
}
