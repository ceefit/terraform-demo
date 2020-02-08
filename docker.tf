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
  }
  networks_advanced {
    name = docker_network.ngrok_network.name
  }
}

resource "docker_container" "ngrok" {
  image = docker_image.ngrok.latest
  name  = "ngrok"
  start = true
  rm    = true
  ports {
    internal = 4040
    external = 4040
  }
  ports {
    internal = 80
    external = 80
  }
  networks_advanced {
    name = docker_network.ngrok_network.name
  }

  links   = [docker_container.seedaware-web.name]
  command = ["ngrok", "http", docker_container.seedaware-web.name]
}

data "external" "ngrok_uri" {
  program    = ["bash", "get_ngrok_uri.sh"]
  depends_on = [docker_container.ngrok]
}

output "ngrok_uri" {
  value = data.external.ngrok_uri.result
}

resource "docker_image" "seedaware-web" {
  name         = "seedaware-web:latest"
  keep_locally = false
}

resource "docker_image" "ngrok" {
  name         = "wernight/ngrok"
  keep_locally = false
}

