# ECS cluster
resource "aws_ecs_cluster" "sys-web" {
  name = "sys-web"
}
#Compute
resource "aws_autoscaling_group" "sys-web-cluster" {
  name                      = "sys-web-cluster"
  vpc_zone_identifier       = ["${aws_subnet.sys-public-1.id}", "${aws_subnet.sys-public-2.id}", "${aws_subnet.sys-public-3.id}"]
  min_size                  = "2"
  max_size                  = "10"
  desired_capacity          = "2"
  launch_configuration      = "${aws_launch_configuration.sys-web-cluster-lc.name}"
  health_check_grace_period = 120
  default_cooldown          = 30
  termination_policies      = ["OldestInstance"]
 
  tag {
    key                 = "Name"
    value               = "ECS-sys-web"
    propagate_at_launch = true
  }
}
 
resource "aws_autoscaling_policy" "sys-web-cluster" {
  name                      = "sys-web-ecs-auto-scaling"
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = "90"
  adjustment_type           = "ChangeInCapacity"
  autoscaling_group_name    = "${aws_autoscaling_group.sys-web-cluster.name}"
 
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
 
    target_value = 40.0
  }
}
 
resource "aws_launch_configuration" "sys-web-cluster-lc" {
  name_prefix     = "sys-web-cluster-lc"
  security_groups = ["${aws_security_group.instance_sg.id}"]
 
  # key_name                    = "${aws_key_pair.sys-webdev.key_name}"
  image_id                    = "${data.aws_ami.sys-ecs-ami.id}"
  instance_type               = "${var.instance_type}"
  iam_instance_profile        = "${aws_iam_instance_profile.ecs-ec2-role.id}"
  user_data                   = "${data.template_file.ecs-cluster.rendered}"
  associate_public_ip_address = true
 
  lifecycle {
    create_before_destroy = true
  }
}
