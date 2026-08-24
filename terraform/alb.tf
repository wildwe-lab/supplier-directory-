resource "aws_lb" "supplier-lb" {
  name               = "supplier-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets = [
    aws_subnet.public-1b.id,
    aws_subnet.public-1a.id
  ]

}
resource "aws_lb_target_group" "frontend-tg" {
  name        = "supplier-frontend-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.ahmed-network.id
  target_type = "ip"

  health_check {
    path     = "/"
    protocol = "HTTP"
  }

  tags = {
    Name = "supplier-frontend-tg"
  }

}
resource "aws_lb_target_group" "backend-tg" {
  name        = "supplier-backend-tg"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.ahmed-network.id
  target_type = "ip"

  health_check {
  path     = "/api/"
  protocol = "HTTP"
}

  tags = {
    Name = "supplier-backend-tg"
  }

}
resource "aws_lb_listener" "http-listener" {
  load_balancer_arn = aws_lb.supplier-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend-tg.arn
  }
}
resource "aws_lb_listener_rule" "backend-rule" {
  listener_arn = aws_lb_listener.http-listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend-tg.arn
  }

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}