provider "docker" {
  host = "tcp://127.0.0.1:2376/"
}

provider "fastly" {
  api_key = var.fastly_api_key
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}