# Подключение провайдера
terraform {
  backend "consul" {
    address = "localhost:8500"
    scheme  = "http"
    path    = "savin"
  }

  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

# Настройки провайдера, указание конкретной папки в облаке
provider "yandex" {
  zone = "ru-central1-a"
  folder_id = "b1gnp1eh23rvdgtl5tn4"
}

# Создание подсети (VPC Subnet) внутри виртуальной приватной сети (VPC)
resource "yandex_vpc_subnet" "main-subnet2" {
  name           = "main-subnet2"
  zone           = "ru-central1-a"
  network_id     = "enpe2272khqu9lsr4bim"
  v4_cidr_blocks = ["192.168.11.0/24"]
}

# Создание диска для подключения к виртуальной машине
resource "yandex_compute_disk" "tf-node-disk2" {
  name       = "tf-node-disk2"
  type       = "network-hdd"
  zone       = "ru-central1-a"
  size       = 10
}

# Второй диск
resource "yandex_compute_disk" "tf-node-disk-additional2" {
  name       = "tf-node-additional2"
  type       = "network-hdd"
  zone       = "ru-central1-a"
  size       = 10
}

# Создание виртуальной машины
resource "yandex_compute_instance" "tf-node2" {
  name = "tf-node2"
  platform_id = "standard-v3"

  # Установка ресурсов
  resources {
    cores  = 2
    memory = 1
    core_fraction = 20
  }

  scheduling_policy {
    preemptible = true
  }

  # Подключение дисков к виртуальной машине
  secondary_disk {
    disk_id = yandex_compute_disk.tf-node-disk2.id
  }

  secondary_disk {
    disk_id = yandex_compute_disk.tf-node-disk-additional2.id
  }

  # Настройки сетевых интерфейсов
  network_interface {
    subnet_id = yandex_vpc_subnet.main-subnet2.id

    # Настройка DNS записи, которая будет вести на текущую виртуальную машину
    dns_record {
      fqdn = "tf-node2.test."
      dns_zone_id = "dns1u11ph0ic749v34ia"
    }
  }

  # Выбор образа, с которого нужно развернуть виртуальную машину
  boot_disk {
    initialize_params {
      # almalinux9 image
      image_id = "fd8cvn7c0lb5ub3ip3kn"
    }
  }

  # Метадата текущей виртуалки для настройки внутренних параметров
  metadata = {
    # Установка возможности использовать консоль из веб-интерфейса
    serial-port-enable = 1
  }
}
