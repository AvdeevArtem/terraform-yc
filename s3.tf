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

# resource "yandex_kms_symmetric_key" "key-s3-bucket" {
#   name              = "s3-bucket-symetric-key"
#   description       = "s3 bucket key"
#   default_algorithm = "AES_128"
#   rotation_period   = "8760h" // equal to 1 year
# }


resource "yandex_storage_bucket" "s3-bucket" {
  access_key = yandex_iam_service_account_static_access_key.s3-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.s3-static-key.secret_key
  bucket     = "avdeev-terraform-state-bucket"
  acl    = "private"
  versioning {
    enabled = true
  }
  # server_side_encryption_configuration {
  #   rule {
  #     apply_server_side_encryption_by_default {
  #       kms_master_key_id = yandex_kms_symmetric_key.key-s3-bucket.id
  #       sse_algorithm     = "aws:kms"
  #     }
  #   }
  # }
}
