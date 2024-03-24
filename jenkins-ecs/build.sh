#!/bin/bash

controller() {
   terraform apply -replace=module.serverless_jenkins.null_resource.build_and_push_image_jenkins_controller -auto-approve
}

agent() {
   terraform apply -replace=module.serverless_jenkins.null_resource.build_and_push_image_jenkins_agent -auto-approve
}

if [ "$1" == "controller" ]; then
    controller
elif [ "$1" == "agent" ]; then
    agent
else
    echo "Invalid argument. Usage: $0 {controller|agent}"
    exit 1
fi