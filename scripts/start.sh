#!/bin/bash
echo "Logging into ECR..."
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
REGION=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/region)
ACCOUNT_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/dynamic/instance-identity/document | grep accountId | awk -F'"' '{print $4}')

ECR_BASE="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com"
APP_NAME="my-app-backend"
CONTAINER_NAME="backend"
APP_PORT="8080"

echo "Deploying $CONTAINER_NAME (Account: $ACCOUNT_ID, Region: $REGION)"
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_BASE

# Start Backend SECOND (proxy depends on it)
echo "Starting Backend on port 8080..."
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true
docker pull $ECR_BASE/$APP_NAME:latest
docker run -d -p  ${APP_PORT}:80 --name $CONTAINER_NAME $ECR_BASE/$APP_NAME:latest

echo "Containers running!"
docker ps
