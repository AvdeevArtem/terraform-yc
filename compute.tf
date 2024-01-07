locals {
    vm_subnet_names = [
    "production-test-ru-central1-a",
    "production-test-ru-central1-b",
    "production-test-ru-central1-c"
  ]
}

resource "yandex_compute_instance" "web" {
  name = "web"
  platform_id = "standard-v3"
  zone = var.yandex_zone[0]

  boot_disk {
    initialize_params {
      image_id = "fd81hgrcv6lsnkremf32"
    }
  }

  network_interface {
    subnet_id          = data.yandex_vpc_subnet.default.subnet_id
    security_group_ids = yandex_vpc_security_group.group1.security_group_ids
  }

  resources {
    cores = 2
    memory = 1
    core_fraction = 20
  }
  scheduling_policy {
    preemptible = true
  }
  metadata = {
    serial-port-enable = 0
  }

  allow_stopping_for_update = true
  depends_on = [
    yandex_vpc_subnet.default
  ]
}
