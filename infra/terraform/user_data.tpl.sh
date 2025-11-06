#!/bin/bash
set -e

# Install Docker, jq, awscli (Ubuntu)
apt-get update -y
apt-get install -y apt-transport-https ca-certificates curl software-properties-common jq

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
usermod -aG docker ubuntu

# Install AWS CLI v2 (deb)
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
apt-get install -y unzip
unzip /tmp/awscliv2.zip -d /tmp
/tmp/aws/install

# Login to ECR (uses instance role, requires AWS CLI)
REGION="${var_region}"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_URI="${ecr_repo_uri}"
aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ECR_URI%/*}

IMAGE="${ecr_repo_uri}:${image_tag}"
docker pull $IMAGE || true
docker rm -f login-backend || true

# Start container: map host 80 to container 8000
docker run -d --name login-backend -p 80:8000 \
  -e S3_BUCKET="${bucket_name}" \
  $IMAGE
