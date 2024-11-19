terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

resource "docker_network" "app_network" {
  name = "app-network"
}

resource "docker_image" "app" {
  name = "app"
  build {
    context    = "./" # Diretório com Dockerfile e app
    dockerfile = "dockerfile"
  }
}

# Redis Image
resource "docker_image" "redis" {
  name         = "redis:alpine"
  keep_locally = false
}

# Postgres Image
resource "docker_image" "postgres" {
  name         = "postgres:13"
  keep_locally = false
}

# Container do app
resource "docker_container" "app" {
  image = docker_image.app.image_id
  name  = "app"

  ports {
    internal = 5000
    external = 5000
  }

  env = ["FLASK_ENV=development", "DEBUG_METRICS=1"]

  networks_advanced {
    name = docker_network.app_network.name
  }
}

# Container do Redis
resource "docker_container" "redis" {
  image = docker_image.redis.image_id
  name  = "redis"

  ports {
    internal = 6379
    external = 6379
  }

  networks_advanced {
    name = docker_network.app_network.name
  }
}

# Container do Postgres
resource "docker_container" "postgres" {
  image = docker_image.postgres.image_id
  name  = "postgres"

  env = ["POSTGRES_USER=user","POSTGRES_PASSWORD=senhafacil","POSTGRES_DB=postgres"]

  ports {
    internal = 5432
    external = 5432
  }

  networks_advanced {
    name = docker_network.app_network.name
  }
}
