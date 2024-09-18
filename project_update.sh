
#!/bin/bash
# ----------------------------------------------------------------------------
# Script for updating Git repository and managing Terraform infrastructure
# ----------------------------------------------------------------------------
# Creation Date: 2024-09-18
# Last Modified: 2024-09-18
# Author: Patryk Kaźmierczak
# Description: This script automates the process of updating the source code
#              repository, initializing Terraform, planning, and applying
#              changes to the infrastructure. 
# ----------------------------------------------------------------------------


# Exit immediately if a command exits with a non-zero status
set -e

# Print each command before executing it
set -x
---------------------------------------------------------------
echo "Updating git repository..."
git pull origin main
echo "Git repository updated."
---------------------------------------------------------------
echo "Initializing Terraform..."
terraform init
echo "Terraform initialized."
---------------------------------------------------------------
echo "Planning Terraform changes..."
terraform plan
echo "Terraform plan complete."
---------------------------------------------------------------
echo "Applying Terraform changes..."
terraform apply -auto-approve
echo "Terraform changes applied."
---------------------------------------------------------------
echo "Update complete."
