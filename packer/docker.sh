#!/bin/bash

# Update package list
sudo apt update

# Install fontconfig and OpenJDK 17
sudo apt install -y fontconfig openjdk-17-jre

# Update package list and install dependencies for Docker
sudo apt-get update
sudo apt-get install -y ca-certificates curl

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository to Apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package list again
sudo apt-get update

# Install Docker packages
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add the user 'ubuntu' to the Docker group (replace 'ubuntu' if needed)
sudo usermod -aG docker ubuntu

# Print a success message
echo "Installation of OpenJDK 17 and Docker completed successfully."
