variable "name" {
  description = "Route53 resolver endpoint name"
  type        = string
}

variable "subnets" {
  description = "A list of VPC Subnet IDs to launch in"
  type        = list(string)
}

variable "forwarders" {
  description = "A list of objects representing forwarders, with associated vpcs, domain name and resolvers ip list"
  type = list(
    object({
      associate_vpcs = list(string)
      domain         = string
      resolvers      = list(string)
    })
  )
  default = []
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = null
}
