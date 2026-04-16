#!/usr/bin/env bash

# Build and Deploy docker image to AWS ECR
# This creates/gets the ECR repo URI
# then runs the Makefile in the bwa/docker directory
# which builds the Docker image for BWA and incorporates
# the src/run_bwa.py onto the image
#
# NOTE: make sure there are no extra files in this directory
#       for example bwa/src/tmp/* as this will cause
#       docker to try and look at the entire directory even
#       the irrelevant files (context) and the docker build
#       will fail.

# Prior to running this code, you need to do docker login
# using this aws command:
#    eval $(aws ecr get-login | sed -e 's/-e none//g')


cd docker


#REPO_URI=$(aws ecr describe-repositories --repository-name star-rnaseq --output text --query "repositories[0].repositoryUri")
#
#if [ -z "$REPO_URI" ]
#then
#    REPO_URI=$(aws ecr create-repository --repository-name star-rnaseq  --output text --query "repository.repositoryUri")
#    echo "Created repo successfully."
#fi

#make REGISTRY=${REPO_URI}

make build

#cd ../../../
cd ../../../
