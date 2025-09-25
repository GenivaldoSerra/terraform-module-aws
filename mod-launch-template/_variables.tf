variable "ami_id" {
  description = "The AMI ID to use for the launch template."
  type        = string
}

variable "instance_type" {
  description = "The instance type to use for the launch template."
  type        = string
}

variable "key_name" {
  description = "The key name to use for the launch template."
  type        = string
}

variable "resource_name" {
  description = "The name to assign to the launch template resource."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the launch template."
  type        = map(string)
  default     = {}
}