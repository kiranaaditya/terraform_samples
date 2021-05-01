variable "external_ip" {
  type    = string
  default = "0.0.0.0/0"
}

variable "instance-type-master" {
  type    = string
  default = "t3.large"
}

variable "instance-type-worker" {
  type    = string
  default = "t3.small"
}

variable "profile" {
  type    = string
  default = "default"
}

variable "region-k8s-sample" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "K8S Sample"
}