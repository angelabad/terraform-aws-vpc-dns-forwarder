output "endpoint_id" {
  description = "Route53 resolver endpoint id"
  value       = module.forwarder.resolver_endpoint_id
}
