# ----------------------------------------------------------------------------
# Script to tag and push Docker images to Docker Hub for frontend and backend
# ----------------------------------------------------------------------------
# Creation Date: 2024-09-18
# Last Modified: 2024-09-18
# Author: Patryk Kaźmierczak
# Description: This script tags and pushes Docker images for frontend and
#              backend applications to Docker Hub. It requires the Docker Hub
#              username as an argument. The script:
#              1. Checks if the Docker Hub username is provided.
#              2. Retrieves the image IDs for the frontend and backend images.
#              3. Tags the images with the latest tag.
#              4. Pushes the tagged images to Docker Hub.
# ----------------------------------------------------------------------------

# Check if Docker Hub username is provided
if ($args.Count -eq 0) {
    Write-Host "Error: Docker Hub username is required."
    Write-Host "Usage: .\docker_push.ps1 <dockerhub_username>"
    exit 1
}

# Set Docker Hub username
$DOCKERHUB_USERNAME = $args[0]

# Define image names
$FRONTEND_IMAGE = "automated-deployment-aws-kubernetes-frontend"
$BACKEND_IMAGE = "automated-deployment-aws-kubernetes-backend"

# Define image tags (latest by default)
$FRONTEND_TAG = "latest"
$BACKEND_TAG = "latest"

# Get Image IDs from `docker images`
$FRONTEND_IMAGE_ID = (docker images -q "${FRONTEND_IMAGE}:${FRONTEND_TAG}")
$BACKEND_IMAGE_ID = (docker images -q "${BACKEND_IMAGE}:${BACKEND_TAG}")

# Check if images exist
if (-not $FRONTEND_IMAGE_ID) {
    Write-Host "Error: Frontend Docker image not found. Make sure the image exists."
    exit 1
}

if (-not $BACKEND_IMAGE_ID) {
    Write-Host "Error: Backend Docker image not found. Make sure the image exists."
    exit 1
}

# Tag and Push Frontend Image
Write-Host "Tagging and pushing frontend image..."
docker tag $FRONTEND_IMAGE_ID "$($DOCKERHUB_USERNAME)/$($FRONTEND_IMAGE):$($FRONTEND_TAG)"
docker push "$($DOCKERHUB_USERNAME)/$($FRONTEND_IMAGE):$($FRONTEND_TAG)"

# Tag and Push Backend Image
Write-Host "Tagging and pushing backend image..."
docker tag $BACKEND_IMAGE_ID "$($DOCKERHUB_USERNAME)/$($BACKEND_IMAGE):$($BACKEND_TAG)"
docker push "$($DOCKERHUB_USERNAME)/$($BACKEND_IMAGE):$($BACKEND_TAG)"

Write-Host "Frontend and Backend images have been successfully pushed to Docker Hub!"
