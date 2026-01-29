#!/bin/bash

# Initial server setup script
# Run this once on your Digital Ocean droplet to set up the application

set -e

APP_DIR="/var/www/node-react-rbac"
REPO_URL="https://github.com/Ganesh-Surna/node-react-rbac.git"

echo "=========================================="
echo "Node React RBAC - Server Setup"
echo "=========================================="
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root (use sudo)"
    exit 1
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
    echo "Docker installed successfully!"
else
    echo "Docker is already installed."
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose is not installed. Installing Docker Compose..."
    apt-get update
    apt-get install -y docker-compose
    echo "Docker Compose installed successfully!"
else
    echo "Docker Compose is already installed."
fi

# Create directory if it doesn't exist
if [ ! -d "$APP_DIR" ]; then
    echo "Creating directory $APP_DIR..."
    mkdir -p $APP_DIR
else
    echo "Directory $APP_DIR already exists."
fi

# Navigate to app directory
cd $APP_DIR

# Clone or update the repository
if [ -d ".git" ]; then
    echo "Repository already exists. Pulling latest changes..."
    git pull origin main
else
    echo "Cloning repository..."
    git clone $REPO_URL .
fi

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    echo ""
    echo "Creating .env file..."
    echo "Please enter your configuration:"
    echo ""
    
    read -p "Enter PORT (default: 5000): " PORT
    PORT=${PORT:-5000}
    
    read -p "Enter MONGODB_URI: " MONGODB_URI
    
    read -p "Enter JWT_SECRET: " JWT_SECRET
    
    cat > .env << EOF
PORT=$PORT
MONGODB_URI=$MONGODB_URI
JWT_SECRET=$JWT_SECRET
NODE_ENV=production
EOF
    
    echo ".env file created successfully!"
    echo ""
    echo "You can edit it later: nano $APP_DIR/.env"
else
    echo ".env file already exists. Skipping creation."
fi

# Set proper permissions
chmod 600 .env 2>/dev/null || true

echo ""
echo "=========================================="
echo "Setup completed!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Verify .env file has correct values: nano $APP_DIR/.env"
echo "2. Build and start containers:"
echo "   cd $APP_DIR"
echo "   docker-compose build"
echo "   docker-compose up -d"
echo "3. Check status: docker-compose ps"
echo "4. View logs: docker-compose logs -f"
echo ""
echo "Application will be available at:"
echo "  Frontend: http://139.59.6.209:3000"
echo "  Backend:  http://139.59.6.209:$PORT"
echo ""

