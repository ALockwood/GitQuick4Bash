#!/bin/bash

#Create docker group, add current user to it
sudo groupadd docker
sudo usermod -aG docker $USER

#Avoid logout & login to update group membership
newgrp docker

#Test
docker run hello-world

#Set docker to start on boot
sudo systemctl enable docker