variable "prefix" {
  description = "The prefix for the resources created in the specified Azure Resource Group"
}

variable "location" {
  default     = "eastus"
  description = "The location for the deployment"
}

variable "ARM_CLIENT_ID" {
  description = "The Client ID (appId) for the Service Principal used for the deployment"
}

variable "ARM_CLIENT_SECRET" {
  description = "The Client Secret (password) for the Service Principal used for the deployment"
}

variable "tenant" {
  description = "Azure tenant to be used"
}

variable "subscription" {
  description = "Azure subscription to be used"
}
