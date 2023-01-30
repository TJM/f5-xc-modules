variable "public_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_workload" {
  type    = string
  default = ""
}

variable "cluster_labels" {
  type    = string
  default = "{}"
}

variable "private_default_gw" {
  type    = string
  default = ""
}

variable "customer_route" {
  type    = string
  default = ""
}

variable "private_vn_prefix" {
  type    = string
  default = ""
}

variable "ssh_public_key" {
  type = string
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_token_name" {
  type = string
}

variable "f5xc_namespace" {
  type = string
}

variable "f5xc_ce_gateway_type_ingress" {
  type    = string
  default = "ingress_gateway"
}

variable "f5xc_ce_gateway_type_ingress_egress" {
  type    = string
  default = "ingress_egress_gateway"
}

variable "f5xc_ce_gateway_type" {
  type = string
  validation {
    condition     = contains(["ingress_egress_gateway", "ingress_gateway"], var.f5xc_ce_gateway_type)
    error_message = format("Valid values for gateway_type: ingress_egress_gateway, ingress_gateway")
  }
}

variable "f5xc_registration_wait_time" {
  type    = number
  default = 60
}

variable "f5xc_registration_retry" {
  type    = number
  default = 20
}

variable "f5xc_aws_vpc_az_nodes" {
  type = map(map(string))
}