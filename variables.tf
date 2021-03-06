####### variables for Instance #######

variable "prefix" {
  description = "Name to be used on all the resources as identifier"
  type        = "string"
  default     = ""
}

variable "vm_count" {
  description = "Should be true if you wanted to deploy internet gateway"
  type        = "string"
  default     = "1"
}

variable "ssh_public_key" {
  description = "Should be true if you wanted to deploy internet gateway"
  type        = "string"
  default     = ""
}

variable "placeholder" {
  description = "Should be true if you wanted to deploy internet gateway"
  type        = "string"
  default     = "placekitten.com"
}

variable "width" {
  description = "Should be true if you wanted to deploy internet gateway"
  type        = "string"
  default     = "600"
}

variable "height" {
  description = "Should be true if you wanted to deploy internet gateway"
  type        = "string"
  default     = "400"
}
