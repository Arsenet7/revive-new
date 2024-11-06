packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  region         = "us-east-2"
  instance_type  = "t2.small"
  source_ami     = "ami-0ea3c35c5c3284d82"  # Replace with the actual AMI ID you want to use
  ami_name       = "packer-example"
  ssh_username   = "ubuntu"
}

build {
  name    = "aws-packer-build"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  
  # Use a file provisioner to upload the Nginx configuration file
  provisioner "file" {
    source      = "docker.sh"  # Path to the local file
    destination = "/tmp/docker.sh"  # Path on the remote instance
  }

  # Use a shell provisioner to move the file to the appropriate location and restart Nginx
  provisioner "shell" {
    inline = ["chmod +x /tmp/docker.sh" ]
  }
  provisioner "shell" {
    inline = ["sudo /tmp/docker.sh"]
  }
}
