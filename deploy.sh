#!/bin/bash

echo "Default region is: europe-west1"

echo "Creating MySQL instance..."


PROJECT_ID="devops-case"
IMAGE_NAME="flask-web-app"
INITIAL_IMAGE_TAG="1.0"

# Mysql Instance

read -rp "Please enter Instance name. default is: [devops-task-mysql]: " INSTANCE_NAME
INSTANCE_NAME=${INSTANCE_NAME:-devops-task-mysql}

read -rp "Please enter MySQL version. default is: [MYSQL_8_0]: " MYSQL_VERSION
MYSQL_VERSION=${MYSQL_VERSION:-MYSQL_8_0}

read -rp "Please enter Ip addresses needs to be accessible by MySQL instance [ex: 1.1.1.1,2.2.2.2] " AUTHORIZED_NETWORKS
AUTHORIZED_NETWORKS=${AUTHORIZED_NETWORKS:-}

read -rp "Please enter MySQL root password. default is: [root]" MYSQL_ROOT_PASSWORD
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-root}

gcloud sql instances create "$INSTANCE_NAME" \
--database-version="$MYSQL_VERSION" \
--cpu=2 \
--memory=4 \
--region=europe-west1 \
--root-password="$MYSQL_ROOT_PASSWORD" \
--authorized-networks="$AUTHORIZED_NETWORKS"

echo "MySQL instance created successfully."

echo "Enabling Google Container Registry"

gcloud services enable container.googleapis.com
gcloud services enable containerregistry.googleapis.com


#k8s Cluster

echo "Creating Kubernetes Cluster for flask web app"

read -rp "Please enter k8s cluster name. default is: [devops-task-cluster]: " CLUSTER_NAME
CLUSTER_NAME=${CLUSTER_NAME:-devops-task-cluster}

gcloud container clusters create "$CLUSTER_NAME" --num-nodes=1 --region=europe-west1

echo "Get authentication credentials for the cluster"
gcloud container clusters get-credentials "$CLUSTER_NAME"  --region=europe-west1

# configure docker credentials for Google Container Registry
gcloud auth configure-docker

echo "Build and Push flask web app to container registry"

docker build --platform=linux/amd64  \
            --tag "gcr.io/$PROJECT_ID/$IMAGE_NAME:$INITIAL_IMAGE_TAG" \
            ./flask-app

docker push "gcr.io/$PROJECT_ID/$IMAGE_NAME:$INITIAL_IMAGE_TAG"


echo "Deploy application to newly created k8s cluster"

kubectl apply -f deployment.yaml
