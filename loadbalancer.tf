resource "aws_lb" "main" {
  name                       = "main"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.allow_http.id]
  subnets                    = [for subnet in var.public_subnets : subnet]
  enable_deletion_protection = false

  tags = var.tags
}

resource "aws_lb_target_group" "main" {
  name     = "tf-main-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = local.vpc_id

}

resource "aws_lb_target_group_attachment" "main" {
  count            = length(aws_instance.this)
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.this[count.index].id
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "example.com"
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}

