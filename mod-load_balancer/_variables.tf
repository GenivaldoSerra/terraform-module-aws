# Variáveis Gerais
variable "name_prefix" {
  description = "Prefixo para nomear recursos criados por este módulo"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]*$", var.name_prefix))
    error_message = "O name_prefix deve conter apenas letras, números e hífens."
  }
}

variable "environment" {
  description = "Ambiente ao qual o load balancer pertence (ex: prod, staging, dev)"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]*$", var.environment))
    error_message = "O environment deve conter apenas letras, números e hífens."
  }
}

variable "tags" {
  description = "Tags a serem aplicadas em todos os recursos"
  type        = map(string)
  default     = {}
}

# Variáveis do Load Balancer
variable "internal" {
  description = "Se true, o load balancer será interno (não acessível pela internet)"
  type        = bool
  default     = false
}

# Variáveis de Access Logs
variable "enable_access_logs" {
  description = "Habilita logs de acesso do ALB"
  type        = bool
  default     = false
}

variable "access_logs_bucket" {
  description = "Nome do bucket S3 para armazenar os logs de acesso"
  type        = string
  default     = null
}

variable "access_logs_prefix" {
  description = "Prefixo para os logs de acesso no bucket S3"
  type        = string
  default     = null
}

variable "load_balancer_type" {
  description = "Tipo do load balancer (application, network, ou gateway)"
  type        = string
  default     = "application"
  validation {
    condition     = contains(["application", "network", "gateway"], var.load_balancer_type)
    error_message = "O tipo do load balancer deve ser 'application', 'network' ou 'gateway'."
  }
}

variable "enable_deletion_protection" {
  description = "Se true, habilita proteção contra deleção do load balancer"
  type        = bool
  default     = true  # Mais seguro por padrão
}

variable "subnet_ids" {
  description = "Lista de IDs de subnets onde o load balancer será criado"
  type        = list(string)
  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "Pelo menos 2 subnets devem ser especificadas para alta disponibilidade."
  }
}

variable "security_group_ids" {
  description = "Lista de IDs de security groups para associar ao load balancer"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "ID da VPC onde o load balancer será criado"
  type        = string
}

# Variáveis de Target Groups
variable "target_groups" {
  description = "Lista de configurações de target groups"
  type = list(object({
    name               = string
    port               = number
    protocol           = string
    protocol_version   = optional(string)
    target_type       = string
    deregistration_delay = optional(number, 300)
    slow_start        = optional(number, 0)
    proxy_protocol_v2 = optional(bool, false)
    preserve_client_ip = optional(bool, true)
    stickiness = optional(object({
      type            = string
      cookie_name     = optional(string)
      cookie_duration = optional(number, 86400)
      enabled        = optional(bool, false)
    }))
    health_check = object({
      enabled             = optional(bool, true)
      interval            = optional(number, 30)
      path                = optional(string, "/")
      port                = optional(string, "traffic-port")
      protocol            = optional(string, "HTTP")
      timeout             = optional(number, 5)
      healthy_threshold   = optional(number, 3)
      unhealthy_threshold = optional(number, 3)
      matcher             = optional(string, "200")
    })
    targets = optional(list(object({
      target_id = string
      port      = optional(number)
      availability_zone = optional(string)
    })), [])
    tags = optional(map(string), {})
  }))
  default = []

  validation {
    condition = alltrue([
      for tg in var.target_groups : can(regex("^[a-zA-Z0-9-]*$", tg.name))
    ])
    error_message = "Os nomes dos target groups devem conter apenas letras, números e hífens."
  }
}

# Variáveis de Listeners
variable "listeners" {
  description = "Lista de configurações de listeners"
  type = list(object({
    name     = string
    port     = number
    protocol = string
    ssl_policy = optional(string)
    certificate_arn = optional(string)
    default_action = object({
      type = string
      forward = optional(object({
        target_groups = list(object({
          target_group_arn = string
          weight = optional(number, 100)
        }))
        stickiness = optional(object({
          duration = optional(number, 1)
          enabled = optional(bool, false)
        }))
      }))
      redirect = optional(object({
        port = optional(string)
        protocol = optional(string)
        host = optional(string)
        path = optional(string)
        query = optional(string)
        status_code = string
      }))
      fixed_response = optional(object({
        content_type = string
        message_body = optional(string)
        status_code = optional(string, "200")
      }))
    })
    rules = optional(list(object({
      priority = number
      conditions = list(object({
        type = string
        values = list(string)
        http_header_name = optional(string)
      }))
      action = object({
        type = string
        forward = optional(object({
          target_groups = list(object({
            target_group_arn = string
            weight = optional(number, 100)
          }))
          stickiness = optional(object({
            duration = optional(number, 1)
            enabled = optional(bool, false)
          }))
        }))
        redirect = optional(object({
          port = optional(string)
          protocol = optional(string)
          host = optional(string)
          path = optional(string)
          query = optional(string)
          status_code = string
        }))
        fixed_response = optional(object({
          content_type = string
          message_body = optional(string)
          status_code = optional(string, "200")
        }))
      })
    })))
  }))
  default = []

  validation {
    condition = alltrue([
      for listener in var.listeners : (
        listener.protocol == "HTTPS" ? 
        (listener.ssl_policy != null && listener.certificate_arn != null) : true
      )
    ])
    error_message = "Certificado SSL e política SSL são obrigatórios para listeners HTTPS."
  }

  validation {
    condition = alltrue([
      for listener in var.listeners : contains(["forward", "redirect", "fixed-response"], listener.default_action.type)
    ])
    error_message = "O tipo de ação deve ser 'forward', 'redirect' ou 'fixed-response'."
  }
}