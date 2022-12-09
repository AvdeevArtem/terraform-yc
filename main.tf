terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = ">= 0.80"
    }
  }
  required_version = "~> 1.3.0"

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "avdeev-terraform-state-bucket"
    region     = "us-east-1"
    key        = "terraform.tfstate"

    skip_credentials_validation = true
  }
}
