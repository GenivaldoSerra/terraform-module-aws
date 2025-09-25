variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 1
}
variable "ami_id" {
  description = "The AMI ID to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "The name of the key pair to use for the instance"
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch the instance in"
  type        = string
}

variable "security_group_ids" {
  description = "A list of security group IDs to associate with the instance"
  type        = list(string)
  default     = []
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP address with the instance"
  type        = bool
  default     = true
}

variable "name_prefix" {
  description = "The name to assign to the instance"
  type        = string
  default     = "my-instance"
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

# Configuração do IMDSv2
variable "metadata_http_endpoint" {
  description = "Enable or disable the HTTP metadata endpoint"
  type        = string
  default     = "enabled"
}

variable "metadata_http_tokens" {
  description = "Require IMDSv2 (tokens) or not (optional)"
  type        = string
  default     = "optional"
}

variable "metadata_http_put_response_hop_limit" {
  description = "The desired HTTP PUT response hop limit for instance metadata requests"
  type        = number
  default     = 1
}

variable "metadata_instance_tags" {
  description = "Enable or disable access to instance tags from the metadata service"
  type        = string
  default     = "disabled"
}