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

module "elasticsearch_virtual_memory_limit_issue" {
  source    = "./modules/elasticsearch_virtual_memory_limit_issue"

  providers = {
    shoreline = shoreline
  }
}