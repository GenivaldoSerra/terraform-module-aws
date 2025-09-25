# AWS Application Load Balancer Terraform Module

Este módulo cria um Application Load Balancer (ALB) na AWS com suporte a múltiplos recursos avançados, incluindo:
- Múltiplos target groups com configurações flexíveis
- Listeners HTTP/HTTPS com regras avançadas
- Balanceamento de carga com pesos
- Redirecionamentos e respostas fixas
- Stickiness sessions
- Health checks configuráveis
- Logs de acesso (opcional)

## Requisitos

- Terraform >= 1.0.0
- AWS Provider >= 4.0.0
- Uma VPC com pelo menos duas subnets públicas
- (Opcional) Certificado SSL no ACM para HTTPS

## Recursos Criados

- Application Load Balancer (`aws_lb`)
- Target Groups (`aws_lb_target_group`)
- Listeners (`aws_lb_listener`)
- Listener Rules (`aws_lb_listener_rule`)
- Target Group Attachments (`aws_lb_target_group_attachment`)

## Uso Básico

```hcl
module "alb" {
  source = "./mod-load_balancer"
  
  name_prefix = "my-app"
  environment = "prod"
  
  # Configurações de Rede
  vpc_id      = "vpc-12345678"
  subnet_ids  = ["subnet-1", "subnet-2"]
  security_group_ids = ["sg-12345678"]
  
  # Target Group Básico
  target_groups = [
    {
      name        = "web"
      port        = 80
      protocol    = "HTTP"
      target_type = "instance"
      health_check = {
        path = "/health"
        port = "traffic-port"
      }
      targets = [
        {
          target_id = "i-1234567890"
          port      = 80
        }
      ]
    }
  ]
  
  # Listener HTTP Básico
  listeners = [
    {
      name     = "http"
      port     = 80
      protocol = "HTTP"
      default_action = {
        type = "forward"
        forward = {
          target_groups = [
            {
              target_group_arn = "web"
              weight          = 100
            }
          ]
        }
      }
    }
  ]
  
  tags = {
    Environment = "prod"
    Project     = "my-app"
  }
}
```

## Exemplos de Uso Avançado

### 1. HTTPS com Redirecionamento HTTP

```hcl
module "alb" {
  source = "./mod-load_balancer"
  
  name_prefix = "my-app"
  
  # ... configurações básicas ...
  
  listeners = [
    {
      name     = "https"
      port     = 443
      protocol = "HTTPS"
      certificate_arn = "arn:aws:acm:region:account:certificate/xxx"
      ssl_policy = "ELBSecurityPolicy-2016-08"
      default_action = {
        type = "forward"
        forward = {
          target_groups = [
            {
              target_group_arn = "web"
              weight = 100
            }
          ]
        }
      }
    },
    {
      name     = "http"
      port     = 80
      protocol = "HTTP"
      default_action = {
        type = "redirect"
        redirect = {
          protocol    = "HTTPS"
          port        = "443"
          status_code = "HTTP_301"
        }
      }
    }
  ]
}
```

### 2. Blue/Green Deployment com Pesos

```hcl
module "alb" {
  source = "./mod-load_balancer"
  
  # ... configurações básicas ...
  
  target_groups = [
    {
      name = "blue"
      port = 80
      protocol = "HTTP"
      health_check = {
        path = "/health"
      }
    },
    {
      name = "green"
      port = 80
      protocol = "HTTP"
      health_check = {
        path = "/health"
      }
    }
  ]
  
  listeners = [
    {
      name     = "http"
      port     = 80
      protocol = "HTTP"
      default_action = {
        type = "forward"
        forward = {
          target_groups = [
            {
              target_group_arn = "blue"
              weight = 90
            },
            {
              target_group_arn = "green"
              weight = 10
            }
          ]
          stickiness = {
            duration = 300
            enabled  = true
          }
        }
      }
    }
  ]
}
```

### 3. Roteamento Baseado em Path com Múltiplas Rules

```hcl
module "alb" {
  source = "./mod-load_balancer"
  
  # ... configurações básicas ...
  
  target_groups = [
    {
      name = "api"
      port = 80
      protocol = "HTTP"
    },
    {
      name = "web"
      port = 80
      protocol = "HTTP"
    },
    {
      name = "admin"
      port = 80
      protocol = "HTTP"
    }
  ]
  
  listeners = [
    {
      name     = "https"
      port     = 443
      protocol = "HTTPS"
      certificate_arn = "arn:aws:acm:region:account:certificate/xxx"
      default_action = {
        type = "forward"
        forward = {
          target_groups = [{ target_group_arn = "web", weight = 100 }]
        }
      }
      rules = [
        {
          priority = 1
          conditions = [
            {
              type = "path-pattern"
              values = ["/api/*"]
            }
          ]
          action = {
            type = "forward"
            forward = {
              target_groups = [{ target_group_arn = "api", weight = 100 }]
            }
          }
        },
        {
          priority = 2
          conditions = [
            {
              type = "path-pattern"
              values = ["/admin/*"]
            },
            {
              type = "source-ip"
              values = ["10.0.0.0/8"]
            }
          ]
          action = {
            type = "forward"
            forward = {
              target_groups = [{ target_group_arn = "admin", weight = 100 }]
            }
          }
        }
      ]
    }
  ]
}
```

### 4. Logs de Acesso (Opcional)

```hcl
module "alb" {
  source = "./mod-load_balancer"
  
  # ... configurações básicas ...
  
  # Configuração de Logs (Opcional)
  enable_access_logs  = true
  access_logs_bucket  = "my-alb-logs"
  access_logs_prefix  = "logs/alb/"
}
```

## Variáveis de Input

### Variáveis Gerais
| Nome | Descrição | Tipo | Default | Obrigatório |
|------|------------|------|---------|-------------|
| name_prefix | Prefixo para nomear recursos | string | - | sim |
| environment | Ambiente (prod, staging, dev, etc) | string | - | sim |
| tags | Tags para todos os recursos | map(string) | {} | não |

### Variáveis do Load Balancer
| Nome | Descrição | Tipo | Default | Obrigatório |
|------|------------|------|---------|-------------|
| internal | Se o ALB será interno | bool | false | não |
| vpc_id | ID da VPC | string | - | sim |
| subnet_ids | IDs das subnets | list(string) | - | sim |
| security_group_ids | IDs dos security groups | list(string) | [] | não |
| enable_deletion_protection | Proteção contra deleção | bool | true | não |

### Variáveis de Target Groups
| Nome | Descrição | Tipo | Default | Obrigatório |
|------|------------|------|---------|-------------|
| target_groups | Lista de configurações de target groups | list(object) | [] | não |

### Variáveis de Listeners
| Nome | Descrição | Tipo | Default | Obrigatório |
|------|------------|------|---------|-------------|
| listeners | Lista de configurações de listeners | list(object) | [] | não |

### Variáveis de Logs
| Nome | Descrição | Tipo | Default | Obrigatório |
|------|------------|------|---------|-------------|
| enable_access_logs | Habilitar logs de acesso | bool | false | não |
| access_logs_bucket | Bucket S3 para logs | string | null | não |
| access_logs_prefix | Prefixo no bucket para logs | string | null | não |

## Outputs

| Nome | Descrição |
|------|------------|
| lb | Atributos do Load Balancer |
| target_groups | Detalhes dos target groups criados |
| listeners | Detalhes dos listeners criados |
| target_group_attachments | Detalhes dos attachments de targets |
| dns_name | DNS name do load balancer |
| zone_id | Route53 zone ID do load balancer |
| target_groups_map | Mapa de nome para ARN dos target groups |

## Funcionalidades Suportadas

1. **Target Groups**:
   - Múltiplos target groups
   - Health checks configuráveis
   - Stickiness sessions
   - Deregistration delay
   - Slow start
   - Preserve client IP

2. **Listeners**:
   - HTTP/HTTPS
   - SSL/TLS com políticas configuráveis
   - Múltiplos listeners por ALB

3. **Rules**:
   - Baseadas em path
   - Baseadas em host
   - Baseadas em headers
   - Baseadas em IP de origem
   - Baseadas em query string
   - Múltiplas condições por rule

4. **Ações**:
   - Forward para target groups
   - Redirect HTTP para HTTPS
   - Respostas fixas personalizadas
   - Balanceamento com pesos

5. **Monitoramento**:
   - Logs de acesso opcionais
   - Tags personalizadas
   - Health checks customizáveis

## Melhores Práticas

1. **Segurança**:
   - Use HTTPS para endpoints públicos
   - Habilite deletion protection em produção
   - Configure security groups apropriados
   - Use políticas SSL/TLS atualizadas

2. **Alta Disponibilidade**:
   - Use múltiplas subnets em AZs diferentes
   - Configure health checks apropriados
   - Use timeouts e thresholds adequados

3. **Monitoramento**:
   - Habilite logs de acesso em produção
   - Use tags consistentes
   - Configure alarmes para health status

## Notas

- Certifique-se de ter as permissões IAM necessárias
- Para HTTPS, o certificado deve estar no ACM
- Para logs de acesso, o bucket S3 deve existir e ter a política correta
- As subnets devem ter acesso à internet para ALB público