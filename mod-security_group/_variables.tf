variable "name_prefix" {
  description = "The prefix to assign to the security group"
  type        = string
  default     = "my-sg"
}

variable "description" {
  description = "The description of the security group"
  type        = string
  default     = "My security group"
}

variable "vpc_id" {
  description = "The ID of the VPC where the security group will be created"
  type        = string
}

variable "ingress_rules" {
  description = "A list of ingress rules to apply to the security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = optional(list(string))
  }))
  default = []
}

variable "egress_rules" {
  description = "A list of egress rules to apply to the security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = optional(list(string))
  }))
  default = []
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}