terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "avdeev-terraform-state-bucket"
    region     = "us-east-1"
    key        = "terraform.tfstate"

    skip_credentials_validation = true
  }
}
