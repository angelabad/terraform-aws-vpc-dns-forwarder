output "resolver_endpoint_id" {
  description = "Route53 resolver endpoint id"
  value       = aws_route53_resolver_endpoint.this.id
}
