terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = "~> 1.12.2"
}

provider "aws" {
  region = "ap-northeast-1"
}
