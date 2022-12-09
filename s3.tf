locals {
  folder_id = "b1g0e14had2hltv69li5"
}

resource "yandex_iam_service_account" "s3" {
  folder_id = local.folder_id
  name        = "s3"
  description = "service account to manage s3"
}

resource "yandex_resourcemanager_folder_iam_member" "s3" {
  folder_id          = local.folder_id
  role               = "storage.admin"
  member             = "serviceAccount:${yandex_iam_service_account.s3.id}"
}

resource "yandex_iam_service_account_static_access_key" "s3-static-key" {
  service_account_id = yandex_iam_service_account.s3.id
  description        = "static access key for object storage"
}

resource "yandex_storage_bucket" "s3-bucket" {
  access_key = yandex_iam_service_account_static_access_key.s3-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.s3-static-key.secret_key
  bucket     = "avdeev-terraform-state-bucket"
  acl    = "private"
  versioning {
    enabled = true
  }
}