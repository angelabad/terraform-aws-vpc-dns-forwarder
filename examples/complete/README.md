# Complete VPC

Configuration in this directory creates set of VPCs and configure and example fully VPC
[DNS outbund forwarder](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-forwarding-outbound-queries.html)
for two domains which redirect traffic through external DNS servers.


## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which can cost money (Route53 resolver, for example). Run `terraform destroy` when you don't need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

No input.

## Outputs

| Name | Description |
|------|-------------|
| endpoint\_id | Route53 resolver endpoint id |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
