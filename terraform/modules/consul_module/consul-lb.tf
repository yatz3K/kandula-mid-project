resource "aws_lb" "consul_ui" {
  name = "kandula-consul-alb"
  internal = false
  load_balancer_type = "application"
  subnets = var.public_subnets_id
  security_groups = [aws_security_group.alb_consul_server.id]
  
  tags = {
    "Name" = "kandula-consul-alb"
  }

}

resource "aws_lb_listener" "consul_ui" {
  load_balancer_arn = aws_lb.consul_ui.arn
  port = "8500"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.consul_ui.arn
  }
}

resource "aws_lb_target_group" "consul_ui" {
  name = "consul-target-group"
  port = 8500
  protocol = "HTTP"
  vpc_id = var.vpc_id

  health_check {
    enabled = true
    path = "/ui/kandula-mid-project"
  }

  tags = {
    "Name" = "consul-target-group"
  }
}

resource "aws_lb_target_group_attachment" "consul_ui" {
  count = length(aws_instance.consul_server)
  target_group_arn = aws_lb_target_group.consul_ui.id
  target_id = aws_instance.consul_server.*.id[count.index]
  port = 8500
}

resource "aws_security_group" "alb_consul_server" {
  name = "kandula-alb-consul-server"
  vpc_id = var.vpc_id
  tags = {
    "Name" = "kandula-alb_consul_server_sccess"
  }
}

resource "aws_security_group_rule" "ui_from_anywhere" {
  description = "access to 8500 consul ui fron anywhere"
  type = "ingress"
  from_port = 8500
  to_port = 8500
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_consul_server.id
}

resource "aws_security_group_rule" "lb_outbound_anywhere" {
  description = "allow outbound anywhere"
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_consul_server.id
}