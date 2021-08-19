# Serverless HTTP Call

Show an http call to a flask app from a serverless function in Azure Functions using Python.

**HTTP Call Chain**
Azure Function (Python) --> Flask App


## Getting Started

### Deploy the flask app
change director to the flask app and execute the build and deploy script.

```bash
cd ./flaskapp
./build_deploy.sh
```

This will create an Azure Resource Group with a Container Registry. It will build the flask app into a Docker container, then deploy the container to an Azure Container Instance.

After it's deployed, note the hostname of the container instance that's printed out from the script to standard out. you can also get the information yourself running the CLI command:

```bash
az container list -g flaskapp --output json
```

### Deploy the Function App

Follow the instructions to deploy the function to Azure using the following options:

- [VS Code](https://docs.microsoft.com/en-us/azure/azure-functions/create-first-function-vs-code-python)
- [CLI](https://docs.microsoft.com/en-us/azure/azure-functions/create-first-function-cli-python?tabs=azure-cli%2Cbash%2Cbrowser)

> NOTE: regardless of deployment method, target the **flaskapp** resource group. This will make it easy to clean up the resources when done with the example

## Test the demo

Make an HTTP call out to the Function App endpoint for the http triggered function. An example local call:

```bash
curl http://localhost:7071/api/httpRequestResponse\?host\=flaskapp-demo.eastus.azurecontainer.io

[2021-08-19T16:29:43.003Z] Executing 'Functions.httpRequestResponse' (Reason='This function was programmatically called via the host APIs.', Id=6ad47ecb-6000-4a14-ab22-b9a7ebd67924)
[2021-08-19T16:29:43.191Z] Response from flaskapp-demo.eastus.azurecontainer.io:
[2021-08-19T16:29:43.191Z] request received = 16:29:42.
```

## Cleanup

### Azure resources

```bash
az group delete -n flaskapp --no-wait --yes
```