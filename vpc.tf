locals {
  subnet_by_folder = {
    "infrastructure" = [
      {
        purpose = "test",
        zone    = "ru-central1-a",
        cidr    = "10.0.0.0/24"
      },

      {
        purpose = "test",
        zone    = "ru-central1-b",
        cidr    = "10.0.1.0/24"
      },

      {
        purpose = "test",
        zone    = "ru-central1-c",
        cidr    = "10.0.2.0/24"
      }
    ]
  }
    zones = [
    "ru-central1-a",
    "ru-central1-b",
    "ru-central1-c"
  ]
  all_subnets = {
    for folder_definition in flatten([
      for folder in keys(local.subnet_by_folder) : [
        for definition in local.subnet_by_folder[folder] : {
          name       = "${folder}-${definition.purpose}-${definition.zone}",
          folder     = folder,
          definition = definition
        }
      ]
    ]) : folder_definition.name => folder_definition
  }
}


resource "yandex_vpc_network" "infrastructure" {
    description = "Default VPC network"
    name = "Infrastructure"
    folder_id = "b1g0e14had2hltv69li5"
}

resource "yandex_vpc_subnet" "default" {
  for_each = local.all_subnets

  name = each.key
  zone       = each.value.definition.zone
  network_id = yandex_vpc_network.infrastructure.id
  v4_cidr_blocks = [each.value.definition.cidr]
  description    = each.value.definition.purpose
}
