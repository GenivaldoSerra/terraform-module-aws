variable "name" {
  description = "The name of the Auto Scaling group"
  type        = string
}

variable "min_size" {
  description = "The minimum size of the Auto Scaling group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "The maximum size of the Auto Scaling group"
  type        = number
  default     = 2
}

variable "availability_zones" {
  description = "List of availability zones to launch resources in."
  type        = list(string)
  default     = ["us-east-1a"]
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "health_check_type" {
  description = "Type of health check (EC2 ou ELB)."
  type        = string
  default     = "EC2"
}

variable "health_check_grace_period" {
  description = "Tempo de tolerância para health check (segundos)."
  type        = number
  default     = 300
}

variable "launch_template_id" {
  description = "ID do Launch Template a ser usado."
  type        = string
}

variable "launch_template_version" {
  description = "Versão do Launch Template."
  type        = string
  default     = "$Latest"
}