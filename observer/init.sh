#!/bin/bash

sudo usermod -aG docker ubuntu

ssh-keygen -t ed25519 -f tunnel/key/id_ed25519
cat tunnel/key/id_ed25519.pub

docker compose build --no-cache
