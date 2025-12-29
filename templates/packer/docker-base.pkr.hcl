packer {
  required_plugins {
    docker = {
      version = ">= 1.1.2"
      source  = "github.com/hashicorp/docker"
    }
    ansible = {
      version = ">= 1.1.4"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

variable "version" {
  type    = string
  default = "x.x.x"
}

locals {
  env_path = "/var/homebrew/linked/cyclonedx-cli/bin/:/home/linuxbrew/.linuxbrew/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"
}

source "docker" "base" {
  image  = "ubuntu:24.04"
  commit = true
  run_command = [
    "-d",
    "-i",
    "-t",
    "{{.Image}}",
    "/bin/bash",
  ]
  changes = [
    "ENV LANG en_US.UTF-8",
    "ENV PATH ${local.env_path}"
  ]
}

build {
  sources = [
    "source.docker.base"
  ]

  name = "base"

  provisioner "shell" {
    inline = [
      "mkdir -p /tmp"
    ]
  }

  provisioner "shell" {
    script = "provisioners/shell/init.sh"
    environment_vars = [
      "ENV_PATH=${local.env_path}"
    ]
  }

  provisioner "shell" {
    script = "provisioners/shell/info-pre.sh"
    environment_vars = [
      "ENV_PATH=${local.env_path}"
    ]
  }

  provisioner "ansible-local" {
    playbook_file = "provisioners/ansible/base.yml"
    galaxy_file = "requirements.yml"
    role_paths = [
      "stage/ansible/roles"
    ]
    collection_paths = [
      "stage/ansible/collections"
    ]
  }

  provisioner "shell" {
    script = "provisioners/shell/info-post.sh"
    environment_vars = [
      "ENV_PATH=${local.env_path}"
    ]
  }

  provisioner "shell-local" {
    script = "provisioners/shell/clean.sh"
    environment_vars = [
      "ENV_PATH=${local.env_path}"
    ]
  }

  post-processor "docker-tag" {
    repository = "cliffano/base"
    tags        = [
      "latest",
      var.version
    ]
  }
}
