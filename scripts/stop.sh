#!/bin/bash
echo "Stopping old containers..."
docker stop backend 2>/dev/null || true
docker rm backend 2>/dev/null || true
echo "Old containers removed."