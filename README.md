# AWS VPC Dns Forwarder Terraform module

[![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/angelabad/terraform-aws-vpc-dns-forwarder)](https://github.com/angelabad/terraform-aws-vpc-dns-forwarder/releases)
[![Vpc Dns Forwarder](https://circleci.com/gh/angelabad/terraform-aws-vpc-dns-forwarder.svg?style=shield)](https://app.circleci.com/pipelines/github/angelabad/terraform-aws-vpc-dns-forwarder)

Terraform module which creates [dns domain forwarder with Route53 Resolver](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-forwarding-outbound-queries.html) on AWS

These types of resources are supported:

* [Route53 Resolver Endpoint](https://www.terraform.io/docs/providers/aws/r/route53_resolver_endpoint.html)
* [Route53 Resolver Rule](https://www.terraform.io/docs/providers/aws/r/route53_resolver_rule.html)

## Features

This module creates one outbound [Route 53 Resolver](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-getting-started.html) and attach defined
[forwarding rules](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-rules-managing.html).

With this configuration your vpcs will resolve these domains with corresponding resolvers.

## Usage

```hcl
module "myendpoint" {
  source  = "angelabad/vpc-dns-forwarder/aws"
  version = "1.0.0"

  name    = "myendpoint"
  subnets = ["subnet-0ab97cbe1bd1406c2", "subnet-0d6cbf60360dbac64"]

  forwarders = [
    {
      associate_vpcs = ["vpc-0435f44681812096b", "vpc-065fb9fa6c4ae13cb"]
      domain         = "angelabad.me"
      resolvers      = ["192.168.1.1"]
    },
    {
      associate_vpcs = ["vpc-0435f44681812096b"]
      domain         = "pastelero.net"
      resolvers      = ["172.16.32.1"]
    }
  ]

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| forwarders | A list of objects representing forwarders, with associated vpcs, domain name and resolvers ip list | <pre>list(<br>    object({<br>      associate_vpcs = list(string)<br>      domain         = string<br>      resolvers      = list(string)<br>    })<br>  )</pre> | `[]` | no |
| name | Route53 resolver endpoint name | `string` | n/a | yes |
| subnets | A list of VPC Subnet IDs to launch in | `list(string)` | n/a | yes |
| tags | A mapping of tags to assign to the resource | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| resolver\_endpoint\_id | Route53 resolver endpoint id |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Angel Abad](https://angelabad.me)

## License

Apache 2 Licensed. See LICENSE for full deatils
