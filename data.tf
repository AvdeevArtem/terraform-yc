data "yandex_vpc_subnet" "default" {
    name = "infrastructure-test-ru-central1-a"
    depends_on = [
      yandex_vpc_subnet.default
    ]
}

data "yandex_vpc_security_group" "group1" {
    name = "My security group"
    depends_on = [
      yandex_vpc_security_group.group1
    ]
}

data "terraform_remote_state" "secrets" {
  backend = "s3"
  config = {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "avdeev-terraform-state-bucket"
    region     = "us-east-1"
    key        = "terraform.tfstate"
    access_key = var.secrets_credentials.access_key
    secret_key = var.secrets_credentials.secret_key

    skip_credentials_validation = true
  }
}
