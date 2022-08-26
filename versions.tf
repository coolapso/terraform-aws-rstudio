terraform {
  required_version = ">= 0.13.0"
  required_providers {
    aws = {
      version = "~>4.28.0"
      source  = "hashicorp/aws"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.4.0"
    }
  }
}
