# AWS Security Group Terraform Module

This module allows you to create a flexible AWS Security Group with support for custom ingress and egress rules, including rules that reference other security groups.

## Features
- Create a security group in a specified VPC
- Flexible ingress and egress rules
- Allow referencing other security groups as source/destination
- Custom tags

## Variables
| Name           | Description                                 | Type           | Default   |
|----------------|---------------------------------------------|----------------|-----------|
| name_prefix    | Prefix for the security group name          | string         | my-sg     |
| description    | Description of the security group           | string         | My security group |
| vpc_id         | VPC ID where the security group is created  | string         | -         |
| ingress_rules  | List of ingress rules (see below)           | list(object)   | []        |
| egress_rules   | List of egress rules (see below)            | list(object)   | []        |
| tags           | Map of tags                                 | map(string)    | {}        |

### Ingress/Egress Rule Object
Each rule object can have:
- `from_port` (number)
- `to_port` (number)
- `protocol` (string)
- `cidr_blocks` (optional, list(string))
- `security_groups` (optional, list(string))

## Example
```hcl
module "sg" {
  source      = "./mod-security_group"
  vpc_id      = "vpc-xxxxxxx"
  name_prefix = "app"
  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      security_groups = ["sg-xxxxxxx"] # Allow another SG to access port 22
    }
  ]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  tags = {
    Environment = "dev"
  }
}
```
