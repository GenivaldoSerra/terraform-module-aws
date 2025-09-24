# AWS Launch Template Terraform Module

Este módulo cria um AWS Launch Template de forma simples e reutilizável.

## Recursos criados

- `aws_launch_template`

## Variáveis

| Nome            | Descrição                                         | Tipo         | Obrigatório |
|-----------------|---------------------------------------------------|--------------|-------------|
| ami_id          | ID da AMI para o Launch Template                  | string       | Sim         |
| instance_type   | Tipo de instância                                 | string       | Sim         |
| key_name        | Nome da chave SSH                                 | string       | Sim         |
| resource_name   | Nome do recurso                                   | string       | Sim         |
| tags            | Tags adicionais (mapa de chave/valor)             | map(string)  | Não         |

## Outputs

| Nome                | Descrição                       |
|---------------------|---------------------------------|
| launch_template_id  | ID do Launch Template criado    |

## Exemplo de uso

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
