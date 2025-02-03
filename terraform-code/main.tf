terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = "ru-central1-a"
}

resource "yandex_compute_disk" "boot-disk-1" {
  name     = "boot-disk-1"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  size     = "20"
  image_id = "fd87c0qpl9prjv5up7mc"
}


#Create a new instance with the name gitlab-server

resource "yandex_compute_instance" "gitlab-server" {
  name = "gitlab-server"
  hostname = "gitlab-server"
  allow_stopping_for_update = true

  resources {
    cores  = 4
    memory = 8
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-1.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
    ip_address = "192.168.10.27"
  }

  metadata = {
    user-data = "${file("./cloud-config.yaml")}"
  }
}

resource "yandex_compute_disk" "boot-disk-2" {
  name     = "boot-disk-2"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  size     = "20"
  image_id = "fd87c0qpl9prjv5up7mc"
}

#Create a new instance with the name stage
resource "yandex_compute_instance" "stage" {
  name = "stage"
  hostname = "stage"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-2.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
    ip_address = "192.168.10.15"
  }

  metadata = {
    user-data = "${file("./cloud-config.yaml")}"
  }
}


resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

output "external_ip_address_gitlab_server" {
  value = yandex_compute_instance.gitlab-server.network_interface.0.nat_ip_address
}

output "external_ip_address_stage" {
  value = yandex_compute_instance.stage.network_interface.0.nat_ip_address
}

output "internal_ip_address_gitlab_server" {
  value = yandex_compute_instance.gitlab-server.network_interface.0.ip_address
}

output "internal_ip_address_stage" {
  value = yandex_compute_instance.stage.network_interface.0.ip_address
}