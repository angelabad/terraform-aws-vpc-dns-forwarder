locals {
  flattenresolvers = formatlist("%s/32", distinct(flatten(var.forwarders[*].resolvers)))
  associate_vpcs = flatten([
    for forwarder_key, forwarder in var.forwarders : [
      for vpc_key, vpc in forwarder.associate_vpcs : {
        forwarder_key = forwarder_key
        vpc           = vpc
        domain        = forwarder.domain
      }
    ]
  ])
}

data "aws_subnet" "current" {
  id = var.subnets[0]
}

resource "aws_security_group" "this" {
  name_prefix = var.name
  vpc_id      = data.aws_subnet.current.vpc_id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "endpoint_dns" {
  count = length(local.flattenresolvers) == 0 ? 0 : 1

  from_port         = 53
  to_port           = 53
  protocol          = -1
  type              = "egress"
  security_group_id = aws_security_group.this.id
  cidr_blocks       = local.flattenresolvers
}

resource "aws_route53_resolver_endpoint" "this" {
  name               = var.name
  direction          = "OUTBOUND"
  security_group_ids = [aws_security_group.this.id]

  dynamic "ip_address" {
    for_each = var.subnets
    content {
      subnet_id = ip_address.value
    }
  }

  tags = var.tags
}

resource "aws_route53_resolver_rule" "this" {
  count = length(var.forwarders)

  name                 = replace(var.forwarders[count.index].domain, ".", "_")
  domain_name          = var.forwarders[count.index].domain
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.this.id

  dynamic "target_ip" {
    for_each = var.forwarders[count.index].resolvers
    content {
      ip   = target_ip.value
      port = 53
    }
  }

  tags = var.tags
}

resource "aws_route53_resolver_rule_association" "this" {
  count = length(local.associate_vpcs)

  resolver_rule_id = aws_route53_resolver_rule.this[local.associate_vpcs[count.index].forwarder_key].id
  vpc_id           = local.associate_vpcs[count.index].vpc
}
