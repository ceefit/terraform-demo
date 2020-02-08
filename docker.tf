resource "docker_network" "ngrok_network" {
  name = "ngrok_network"
}

resource "docker_container" "seedaware-web" {
  image = docker_image.seedaware-web.latest
  name  = "webserver"
  start = true
  rm    = true
  ports {
    internal = 80
    external = 9999
  }
}

resource "docker_image" "seedaware-web" {
  name         = "seedaware-web:latest"
  keep_locally = false
}
