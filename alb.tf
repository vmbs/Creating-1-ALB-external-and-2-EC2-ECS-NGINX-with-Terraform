## ALB
resource "aws_alb" "sys-eu-alb" {
  name            = "sys-web-eu-alb"
  subnets         = ["${aws_subnet.sys-public-1.id}", "${aws_subnet.sys-public-2.id}", "${aws_subnet.sys-public-3.id}"]
  security_groups = ["${aws_security_group.lb_sg.id}"]
  enable_http2    = "true"
  idle_timeout    = 600
}
 
output "alb_output" {
  value = "${aws_alb.sys-eu-alb.dns_name}"
}
 
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = "${aws_alb.sys-eu-alb.id}"
  port              = "80"
  protocol          = "HTTP"
 
  default_action {
    target_group_arn = "${aws_alb_target_group.nginx.id}"
    type             = "forward"
  }
}
 
resource "aws_alb_target_group" "nginx" {
  name       = "nginx"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = "${aws_vpc.sys-vpc.id}"
  depends_on = ["aws_alb.sys-eu-alb"]
 
  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400
  }
 
  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    matcher             = "200,301,302"
  }
}
