#!/bin/bash

set -e

echo "Install AWS cli"

sudo apt-get update
sudo apt-get install -y unzip

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

aws --version

if [ $? -ne 0 ]; then
    echo "Failed to install aws S3"
    exit 1
fi

echo "Done"
exit 0
