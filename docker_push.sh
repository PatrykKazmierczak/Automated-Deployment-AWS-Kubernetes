#!/bin/bash

# Script to tag and push Docker images to Docker Hub for frontend and backend

# Check if Docker Hub username is provided
if [ -z "$1" ]; then
  echo "Error: Docker Hub username is required."
  echo "Usage: ./docker_push.sh <dockerhub_username>"
  exit 1
fi

# Set Docker Hub username
DOCKERHUB_USERNAME=$1

# Define image names
FRONTEND_IMAGE="automated-deployment-aws-kubernetes-frontend"
BACKEND_IMAGE="automated-deployment-aws-kubernetes-backend"

# Define image tags (latest by default)
FRONTEND_TAG="latest"
BACKEND_TAG="latest"

# Get Image IDs from `docker images`
FRONTEND_IMAGE_ID=$(docker images -q $FRONTEND_IMAGE:$FRONTEND_TAG)
BACKEND_IMAGE_ID=$(docker images -q $BACKEND_IMAGE:$BACKEND_TAG)

# Check if images exist
if [ -z "$FRONTEND_IMAGE_ID" ]; then
  echo "Error: Frontend Docker image not found. Make sure the image exists."
  exit 1
fi

if [ -z "$BACKEND_IMAGE_ID" ]; then
  echo "Error: Backend Docker image not found. Make sure the image exists."
  exit 1
fi

# Tag and Push Frontend Image
echo "Tagging and pushing frontend image..."
docker tag $FRONTEND_IMAGE_ID $DOCKERHUB_USERNAME/$FRONTEND_IMAGE:$FRONTEND_TAG
docker push $DOCKERHUB_USERNAME/$FRONTEND_IMAGE:$FRONTEND_TAG

# Tag and Push Backend Image
echo "Tagging and pushing backend image..."
docker tag $BACKEND_IMAGE_ID $DOCKERHUB_USERNAME/$BACKEND_IMAGE:$BACKEND_TAG
docker push $DOCKERHUB_USERNAME/$BACKEND_IMAGE:$BACKEND_TAG

echo "Frontend and Backend images have been successfully pushed to Docker Hub!"


#Explanation:
#Username: The Docker Hub username is passed as a parameter when running the script.
#Image IDs: The script uses docker images -q to get the image IDs of automated-deployment-aws-kubernetes-frontend and automated-deployment-aws-kubernetes-backend.
#Tag and Push: It tags the images with the latest tag and pushes them to your Docker Hub account.
#How to Use the Script:
#Make the script executable:

#bash
#Skopiuj kod
#chmod +x docker_push.sh
#Run the script and pass your Docker Hub username:

#bash
#Skopiuj kod
#./docker_push.sh yourusername
#This will:

#Tag both the frontend and backend images.
#Push them to your Docker Hub account under the latest tag.
#Example:
#bash
#Skopiuj kod
#./docker_push.sh patryk
#This command will:

#Tag automated-deployment-aws-kubernetes-frontend with patryk/automated-deployment-aws-kubernetes-frontend:latest.
#Tag automated-deployment-aws-kubernetes-backend with patryk/automated-deployment-aws-kubernetes-backend:latest.
#Push both images to Docker Hub under your account.