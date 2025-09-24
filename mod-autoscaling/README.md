
# AWS Auto Scaling Group Terraform Module

Este módulo cria e gerencia um Auto Scaling Group (ASG) na AWS, permitindo escalar instâncias automaticamente conforme demanda e com flexibilidade de configuração.

## Recursos Criados
- `aws_autoscaling_group`

## Variáveis
| Nome                      | Descrição                                         | Tipo         | Obrigatório | Default         |
|---------------------------|---------------------------------------------------|--------------|-------------|-----------------|
| name                      | Nome do Auto Scaling Group                        | string       | Sim         | -               |
| min_size                  | Tamanho mínimo do grupo                           | number       | Não         | 1               |
| max_size                  | Tamanho máximo do grupo                           | number       | Não         | 2               |
| availability_zones        | Lista de zonas de disponibilidade                 | list(string) | Não         | ["us-east-1a"]  |
| tags                      | Mapa de tags para o recurso                       | map(string)  | Não         | {{}}            |
| health_check_type         | Tipo de health check (EC2 ou ELB)                 | string       | Não         | "EC2"           |
| health_check_grace_period | Tempo de tolerância para health check (segundos)  | number       | Não         | 300             |
| launch_template_id        | ID do Launch Template a ser usado                 | string       | Sim         | -               |
| launch_template_version   | Versão do Launch Template                         | string       | Não         | "$Latest"       |
---

## Outputs
| Nome                     | Descrição                       |
|--------------------------|---------------------------------|
| autoscaling_group_id     | ID do Auto Scaling Group        |
| autoscaling_group_name   | Nome do Auto Scaling Group      |
| autoscaling_group_arn    | ARN do Auto Scaling Group       |
---

## Exemplo de Uso
```hcl
module "autoscaling" {
  source                   = "./mod-autoscaling"
  name                     = "meu-asg"
  min_size                 = 1
  max_size                 = 3
  availability_zones       = ["us-east-1a", "us-east-1b"]
  tags                     = {
    Environment = "dev"
    Owner       = "usuario"
  }
  health_check_type        = "EC2"
  health_check_grace_period= 300
  launch_template_id       = "lt-xxxxxxxx"
  launch_template_version  = "$Latest"
}
```
---

## Observações
- O módulo espera que um Launch Template já exista e seja referenciado corretamente via `launch_template_id`.
- As tags são propagadas para instâncias lançadas pelo ASG.
- Adapte as variáveis conforme sua necessidade.
