
# Terraform Module AWS

Este repositório contém módulos Terraform reutilizáveis para provisionamento de recursos AWS. Os módulos são organizados em subdiretórios e podem ser utilizados em diferentes projetos para padronizar e acelerar a infraestrutura como código.

## Estrutura dos Módulos

- `mod-launch-template/`: Cria e gerencia AWS Launch Templates.
- `mod-s3/`: Cria e gerencia buckets S3.

## Como Usar

1. Clone este repositório ou adicione como submódulo em seu projeto.
2. Importe o módulo desejado no seu código Terraform:

### Exemplo Launch Template
```hcl
module "launch_template" {
	source         = "./mod-launch-template"
	ami_id         = "ami-xxxxxxxx"
	instance_type  = "t3.micro"
	key_name       = "minha-chave"
	resource_name  = "meu-launch-template"
	tags           = {
		Environment = "dev"
		Owner       = "meu-usuario"
	}
}
```

### Exemplo S3 Bucket
```hcl
module "s3_bucket" {
	source      = "./mod-s3"
	bucket_name = "meu-bucket"
	region      = "us-east-1"
}
```

## Recomendações

- Consulte o README de cada módulo para detalhes de variáveis e outputs.
- Adapte os exemplos conforme sua necessidade.

## Objetivo

Facilitar o uso de módulos Terraform para AWS, promovendo reutilização, padronização e boas práticas DevOps.
