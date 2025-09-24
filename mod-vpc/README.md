# AWS VPC Terraform Module

Este módulo permite criar uma VPC AWS flexível, com suporte opcional para subnets públicas/privadas, Internet Gateway, NAT Gateway e Elastic IP.

## Recursos Criados
- VPC
- Subnets públicas e privadas
- Internet Gateway
- NAT Gateway (opcional)
- Elastic IP para NAT Gateway (opcional)

## Variáveis Principais
| Nome                | Descrição                                      | Tipo         | Default         |
|---------------------|------------------------------------------------|--------------|-----------------|
| name                | Nome da VPC                                    | string       | -               |
| cidr_block          | CIDR da VPC                                    | string       | -               |
| enable_dns_hostnames| Habilita DNS hostnames                         | bool         | true            |
| enable_dns_support  | Habilita DNS support                           | bool         | true            |
| tags                | Tags para todos os recursos                    | map(string)  | {{}}            |
| public_subnet_cidrs | Lista de CIDRs para subnets públicas           | list(string) | []              |
| public_subnet_azs   | Lista de AZs para subnets públicas             | list(string) | []              |
| private_subnet_cidrs| Lista de CIDRs para subnets privadas           | list(string) | []              |
| private_subnet_azs  | Lista de AZs para subnets privadas             | list(string) | []              |
| create_nat_gateway  | Cria NAT Gateway e EIP para subnets privadas   | bool         | false           |

## Outputs
| Nome             | Descrição                       |
|------------------|---------------------------------|
| vpc_id           | ID da VPC criada                |
| vpc_arn          | ARN da VPC criada               |
| vpc_cidr_block   | CIDR da VPC                     |
| vpc_tags         | Tags aplicadas à VPC            |
| nat_gateway_id   | ID do NAT Gateway (se criado)   |
| nat_eip_id       | ID do Elastic IP (se criado)    |

## Exemplo de Uso
```hcl
module "vpc" {
  source              = "./mod-vpc"
  name                = "minha-vpc"
  cidr_block          = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24"]
  public_subnet_azs   = ["us-east-1a"]
  private_subnet_cidrs= ["10.0.2.0/24"]
  private_subnet_azs  = ["us-east-1a"]
  create_nat_gateway  = true
  tags                = {
    Environment = "dev"
    Owner       = "usuario"
  }
}
```

## Observações
- O NAT Gateway e o Elastic IP só serão criados se `create_nat_gateway = true`.
- As subnets públicas/privadas são opcionais, basta não informar os CIDRs.
- O módulo é flexível para compor infraestruturas AWS modulares.
