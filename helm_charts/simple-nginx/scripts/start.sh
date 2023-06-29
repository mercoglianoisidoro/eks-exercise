#!/bin/bash



apt update
apt install -y curl unzip less stress curl
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update


# aws s3api   list-buckets
stress --cpu 2 --timeout 6000

i=0
sleepTime=3
while true
do
  echo "here I am, i=$i"
  i=$((i=i+1))

  echo "----------------  sleeping for $sleepTime  .... "
  sleep $sleepTime
done