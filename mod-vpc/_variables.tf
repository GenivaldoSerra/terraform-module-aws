variable "name" {
  description = "The name of VPC"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC"
  type        = bool
  default     = true
}
variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "public_subnet_cidrs" {
  description = "Lista de CIDRs para subnets públicas"
  type        = list(string)
  default     = []
}

variable "public_subnet_azs" {
  description = "Lista de AZs para subnets públicas"
  type        = list(string)
  default     = []
}

variable "private_subnet_cidrs" {
  description = "Lista de CIDRs para subnets privadas"
  type        = list(string)
  default     = []
}

variable "private_subnet_azs" {
  description = "Lista de AZs para subnets privadas"
  type        = list(string)
  default     = []
}

variable "create_nat_gateway" {
  description = "Se verdadeiro, cria NAT Gateway e EIP para subnets privadas"
  type        = bool
  default     = false
}