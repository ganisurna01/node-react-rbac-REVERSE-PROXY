#!/bin/bash

# Deployment script for Digital Ocean Droplet
# This script sets up the application in /var/www/node-react-rbac

set -e

APP_DIR="/var/www/node-react-rbac"
REPO_URL="https://github.com/Ganesh-Surna/node-react-rbac.git"

echo "Starting deployment..."

# Create directory if it doesn't exist
if [ ! -d "$APP_DIR" ]; then
    echo "Creating directory $APP_DIR..."
    mkdir -p $APP_DIR
fi

# Navigate to app directory
cd $APP_DIR

# Clone or pull the repository
if [ -d ".git" ]; then
    echo "Pulling latest changes..."
    git pull origin main
else
    echo "Cloning repository..."
    git clone $REPO_URL .
fi

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    echo "Creating .env file..."
    cat > .env << EOF
PORT=5000
MONGODB_URI=your_mongodb_uri_here
JWT_SECRET=your_jwt_secret_here
EOF
    echo "Please update .env file with your actual values!"
fi

# Stop existing containers
echo "Stopping existing containers..."
docker-compose down || true

# Build and start containers
echo "Building and starting containers..."
docker-compose build --no-cache
docker-compose up -d

# Show container status
echo "Container status:"
docker-compose ps

echo "Deployment completed!"

