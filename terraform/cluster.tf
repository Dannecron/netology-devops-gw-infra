resource "random_shuffle" "netology-gw-subnet-random" {
  input        = [yandex_vpc_subnet.netology-gw-subnet-a.id, yandex_vpc_subnet.netology-gw-subnet-b.id]
  result_count = 1
}

resource "yandex_compute_instance" "k8s-cluster" {
  for_each = toset(["control", "node01", "node02"])

  name = each.key

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8kdq6d0p8sij7h5qe3" # ubuntu-20-04-lts-v20220822
      size = "40"
      type = "network-ssd"
    }
  }

  network_interface {
    subnet_id = random_shuffle.netology-gw-subnet-random.result[0]
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

output "cluster_ips" {
  value = {
    internal = values(yandex_compute_instance.k8s-cluster)[*].network_interface.0.ip_address
    external = values(yandex_compute_instance.k8s-cluster)[*].network_interface.0.nat_ip_address
  }
}
