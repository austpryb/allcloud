
variable "region" {
  type = string
  default = "eastus"
  description = "azure region"
}

variable "cluster_name" {
  type = string
}

variable "processor" {
 type = string
}

variable "min_size"{
  type = number
}

variable "max_size"{
  type = number
}

