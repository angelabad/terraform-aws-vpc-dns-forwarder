provider "aws" {
  region = "eu-west-2"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_vpc" "one" {
  cidr_block = "192.168.0.0/16"
}

resource "aws_vpc" "two" {
  cidr_block = "172.16.0.0/26"
}

resource "aws_vpc" "tree" {
  cidr_block = "192.168.0.0/16"
}

module "forwarder" {
  source = "../../"

  name    = "forwarder"
  subnets = data.aws_subnet_ids.default.ids

  forwarders = [
    {
      associate_vpcs = [aws_vpc.one.id, aws_vpc.two.id, data.aws_vpc.default.id]
      domain         = "pastelero.net"
      resolvers      = ["172.16.33.1", "192.168.1.1"]
    },
    {
      associate_vpcs = [aws_vpc.one.id, data.aws_vpc.default.id]
      domain         = "angelabad.me"
      resolvers      = ["172.16.33.1", "172.16.50.1"]
    }
  ]
}