terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "kubernetes_misconfigured_ingress_resources" {
  source    = "./modules/kubernetes_misconfigured_ingress_resources"

  providers = {
    shoreline = shoreline
  }
}