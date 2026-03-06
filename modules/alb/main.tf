resource "aws_lb" "web_alb" {
  name               = "${terraform.workspace}-web-alb"
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [var.alb_sg_id]

  access_logs {
    bucket  = aws_s3_bucket.alb_logs.id
    enabled = true
  }

  depends_on = [aws_s3_bucket_policy.alb_logs_policy]

  tags = merge(
    { Name = "${terraform.workspace}-web-alb" },
    var.tags
  )
}

resource "aws_wafv2_web_acl_association" "alb_waf" {
  count        = var.enable_waf ? 1 : 0
  resource_arn = aws_lb.web_alb.arn
  web_acl_arn  = var.waf_acl_arn
}

resource "aws_lb_target_group" "web_tg" {
  name     = "${terraform.workspace}-web-tg"
  port     = var.app_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }

  tags = merge(
    { Name = "${terraform.workspace}-web-tg" },
    var.tags
  )
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}