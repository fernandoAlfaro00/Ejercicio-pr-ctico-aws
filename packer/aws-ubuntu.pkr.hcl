variable "ami_prefix" {
  type    = string
  default = "ubuntu-encrypt-aws"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = "t3.micro"
  region        = "us-east-1"
  encrypt_boot  = true
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"

  tags = {
    OS_Version = "Ubuntu"
    Release    = "Latest"
    Custom     = "True"
  }
}

build {
  name = "ubuntu-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  provisioner "shell" {
    inline = [
      "echo Installing ansible",
      "sleep 30",
      "sudo apt-get update",
      "sudo apt-get install -y ansible",
    ]
  }
  provisioner "ansible-local" {
    playbook_file = "./playbook.yml"
  }
}