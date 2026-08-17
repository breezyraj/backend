#!/bin/bash
echo "Logging into ECR..."
ECR_BASE="371320329671.dkr.ecr.us-east-1.amazonaws.com"
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_BASE

# Start Backend SECOND (proxy depends on it)
echo "Starting Backend on port 8080..."
docker stop backend 2>/dev/null || true
docker rm backend 2>/dev/null || true
docker pull $ECR_BASE/my-app-backend:latest
docker run -d -p 8080:80 --name backend $ECR_BASE/my-app-backend:latest

echo "Containers running!"
docker ps
