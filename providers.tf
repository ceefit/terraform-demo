provider "docker" {
  host = "tcp://10.0.0.25:2376/"
}

provider "fastly" {
  api_key = var.fastly_api_key
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}