resource "yandex_vpc_network" "netology-gw-network" {
  name = "netology-gw-network"
}

resource "yandex_vpc_subnet" "netology-gw-subnet-a" {
  name           = "netology-gw-subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.netology-gw-network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "netology-gw-subnet-b" {
  name           = "netology-gw-subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.netology-gw-network.id
  v4_cidr_blocks = ["192.168.15.0/24"]
}
