#!/bin/bash

# this simply builds a test flask app, builds a container to deploy it to an azure container instance
resource_group=flaskapp
az group create --name $resource_group --location eastus -o json

# container registry, name must be unique
registry_name=flaskapp007
registry_server=$registry_name.azurecr.io
image_name="$registry_server/flaskapp:latest"

az acr create \
    --resource-group $resource_group \
    --name $registry_name \
    --sku Basic

# login
az acr login --name $registry_name 

docker build --tag flaskapp .
docker tag flaskapp $image_name

echo "push image to docker "
docker push $image_name
docker rmi $image_name

#az acr repository list --name $registry_name --output table

# admin credentials (only for demo purposes)
az acr update -g $resource_group -n $registry_name --admin-enabled true
registry_username=$(az acr credential show -g $resource_group -n $registry_name --query "username" -o tsv)
registry_password=$(az acr credential show -g $resource_group -n $registry_name --query "passwords[0].value" -o tsv)

az container create \
    --resource-group $resource_group \
    --name flaskapp \
    --image $image_name \
    --registry-login-server $registry_server \
    --registry-username $registry_username \
    --registry-password $registry_password \
    --dns-name-label flaskapp-demo \
    --ports 5000

app_host=$(az container show -g $resource_group -n flaskapp --query "ipAddress.fqdn" -o tsv)

echo "HOST = $app_host"
echo "PORT = 5000"