# AWS EC2 Terraform Module

This module allows you to create one or multiple EC2 instances in AWS with flexible configuration.

## Features
- Create one or more EC2 instances using `instance_count` variable
- Custom tags, security groups, subnet, and key pair
- IMDSv2 configuration support

## Variables
| Name                        | Description                                      | Type           | Default      |
|-----------------------------|--------------------------------------------------|----------------|--------------|
| ami_id                      | The AMI ID to use for the instance(s)            | string         | -            |
| instance_type               | The type of instance to start                    | string         | t2.micro     |
| key_name                    | The name of the key pair                         | string         | ""           |
| subnet_id                   | The VPC Subnet ID                                | string         | -            |
| security_group_ids          | List of security group IDs                       | list(string)   | []           |
| associate_public_ip         | Associate a public IP address                    | bool           | true         |
| name_prefix                 | Name prefix for the instance(s)                  | string         | my-instance  |
| tags                        | Map of tags to assign                            | map(string)    | {}           |
| instance_count              | Number of EC2 instances to create                | number         | 1            |
| metadata_http_endpoint      | Enable/disable HTTP metadata endpoint            | string         | enabled      |
| metadata_http_tokens        | IMDSv2 tokens required/optional                  | string         | optional     |
| metadata_http_put_response_hop_limit | IMDSv2 hop limit                        | number         | 1            |
| metadata_instance_tags      | Enable/disable access to instance tags           | string         | disabled     |

## Outputs
| Name                | Description                              |
|---------------------|------------------------------------------|
| instance_ids        | IDs of the created EC2 instances         |
| instance_arns       | ARNs of the created EC2 instances        |
| instance_public_ips | Public IPs of the EC2 instances          |
| instance_private_ips| Private IPs of the EC2 instances         |
| instance_public_dns | Public DNS names of the EC2 instances    |

## Example
```hcl
module "ec2" {
  source           = "./mod-ec2"
  ami_id           = "ami-xxxxxxxx"
  instance_type    = "t3.micro"
  subnet_id        = "subnet-xxxxxxx"
  security_group_ids = ["sg-xxxxxxx"]
  key_name         = "my-key"
  name_prefix      = "web"
  instance_count   = 2
  tags = {
    Environment = "dev"
    Owner       = "user"
  }
}
```
