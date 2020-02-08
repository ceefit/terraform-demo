provider "docker" {
  host = "tcp://127.0.0.1:2376/"
}

resource "docker_container" "webserver" {
  image = docker_image.nginx.latest
  name  = "webserver"
  start = true
  ports {
    internal = 80
    external = 9999
  }
}

resource "docker_image" "nginx" {
  name = "nginx:latest"
}