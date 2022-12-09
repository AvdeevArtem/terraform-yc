variable "yandex_zone" {
  description = "Yandex default zone"
  type = list(string)
  default = [
    "ru-central1-a"
  ]
}

variable "yandex_subnet_cidr_blocks" {
  description = "Available cidr blocks for private subnets."
  type        = list(string)
  default     = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24"
  ]
}

variable "resource_tags" {
  description = "Tags to set for all resources"
  type        = map(string)
  default     = {
    project     = "project-alpha",
    environment = "dev"
  }
}

variable "secrets_credentials" {
  type = object({
    access_key = string
    secret_key = string
  })
}
