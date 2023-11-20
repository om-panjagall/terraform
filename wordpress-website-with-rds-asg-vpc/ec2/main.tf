data "aws_ami" "ubuntu" {
   most_recent      = true
}
resource "aws_launch_template" "wordpress" {
  name_prefix   = "wordpress"
  description   = "WordPress launch template"
  instance_type = var.instance_type
  key_name      = var.aws_key_name
  image_id = data.aws_ami.ubuntu.id
  security_group_names = var.security_groups
  
  
  user_data = "${base64encode(file("userdata/user_data.sh"))}"
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 10
      volume_type = "gp2"
    }
  }
}

resource "aws_autoscaling_group" "wordpress" {
  name             = "wordpress-asg"
  desired_capacity = 2
  max_size         = 4
  min_size         = 2
  launch_template {
    id = aws_launch_template.wordpress.id
  }
  target_group_arns    = [aws_lb_target_group.wordpress.arn]
  vpc_zone_identifier  = var.public_subnet_ids
  termination_policies = ["OldestLaunchConfiguration"]

  tag {
    key                 = "Name"
    value               = "wordpress-instance"
    propagate_at_launch = true
  }
}

resource "aws_lb" "wordpress" {
  
  name               = "wordpress-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = "${var.public_subnet_ids}"

  enable_deletion_protection       = false
  enable_http2                     = true
  enable_cross_zone_load_balancing = true
  security_groups                  = var.security_groups
  
}

resource "aws_lb_listener" "wordpress" {
  load_balancer_arn = aws_lb.wordpress.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
    }
  }
}

resource "aws_lb_target_group" "wordpress" {
  name        = "wordpress-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
}

resource "aws_lb_target_group_attachment" "wordpress" {
  count            = 2
  target_group_arn = aws_lb_target_group.wordpress.arn
  target_id        = aws_autoscaling_group.wordpress.id
}





