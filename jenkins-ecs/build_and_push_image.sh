#!/bin/bash

IMAGE_TYPE=$1
AWS_REGION=$2
REPO_ENDPOINT=$3
MODULE_PATH=$4
REPOSITORY_URL=$5

echo "--- JENKINS $IMAGE_TYPE ---"


JENKINS_CONTROLLER_USER="admin"
JENKINS_CONTROLLER_PASS="admin"

# Log in to AWS ECR
aws ecr get-login-password --region $AWS_REGION | sudo docker login --username AWS --password-stdin $REPO_ENDPOINT

# Build the Docker image for the controller with build arguments for Jenkins username and password
if [ "$IMAGE_TYPE" == "controller" ]; then
  sudo docker build -t "jenkins-$IMAGE_TYPE" \
    --build-arg JENKINS_USER=$JENKINS_CONTROLLER_USER \
    --build-arg JENKINS_PASS=$JENKINS_CONTROLLER_PASS \
    $MODULE_PATH/../docker/jenkins_$IMAGE_TYPE --platform linux/amd64
else
  # Build the Docker image for other types without build arguments
  sudo docker build -t "jenkins-$IMAGE_TYPE" $MODULE_PATH/../docker/jenkins_$IMAGE_TYPE --platform linux/amd64
fi

# Tag and push the Docker image
sudo docker tag "jenkins-$IMAGE_TYPE:latest" "$REPOSITORY_URL:latest"
sudo docker push "$REPOSITORY_URL:latest"
