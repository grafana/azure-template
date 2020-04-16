# Grafana Azure Marketplace Offer

## Development

For an introduction to create Azure Marketplace offers, you should read
[this article](https://docs.microsoft.com/en-us/azure/marketplace/partner-center-portal/create-new-azure-apps-offer).

### API Reference

Read the main Azure Resource Manager (AKA ARM) template
[reference](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-syntax)
in order to understand how to write mainTemplate.json (an ARM template). To
understand how to declare resources in your template, see the resource
[reference](https://docs.microsoft.com/en-us/azure/templates/).

### Validation

In order to validate mainTemplate.json, you can use the
[Azure CLI](https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest)
command `az` as follows:

```bash
az login
# We must set the _artifactsLocation parameter since for some reason the
# default won't work when validating

az group create --name yourtestname --location "westcentralus"

az deployment group validate -g yourtestname -f mainTemplate.json \
  -p _artifactsLocation=https://github.com/grafana/azure-marketplace/tree/master/
```

Test the install script by deploying the template to Azure with this command. The `_artifactsLocation` parameter has to have a trailing slash.

```bash
az deployment group create -g yourtestname -f mainTemplate.json -p _artifactsLocation=https://raw.githubusercontent.com/grafana/azure-template/yourbranch/ -p sshPassword=aPassword
```

A list of parameters needs to be filled in:

- `sshUsername` is the username for ssh-ing into the VM that is created. E.g. `ssh daniel@yourtestname.westcentralus.cloudapp.azure.com`.
- `grafanaAdminPassword` is the initial admin password for Grafana at `http://yourtestname.westcentralus.cloudapp.azure.com:3000`.

For the rest of the parameters, enter the same name as the resource group that you created previously with the `az group create` command e.g. `yourtestname`.

- `publicIPAddressName` - the deployment will create a public IP address.
- `domainNamePrefix` - used for the first part of the url when the deployment creates a DNS name.
- `storageAccountName`- the deployment will create a [storage account](https://portal.azure.com/#blade/HubsExtension/BrowseResource/resourceType/Microsoft.Storage%2FStorageAccounts).
- `virtualNetworkName` - the deployment will create a virtual network.

### Troubleshooting

If the last step of the deployment fails, you can ssh into the VM to troubleshoot with the username and password that you specified above. There are some log files that you can check. Details [here](https://github.com/Azure/custom-script-extension-linux#3-troubleshooting).

The VM extension for the script can be found in the portal under extensions ([here for the staging VM](https://portal.azure.com/#@grafana.com/resource/subscriptions/44693801-6ee6-49de-9b2d-9106972f9572/resourceGroups/grafanastaging/providers/Microsoft.Compute/virtualMachines/grafana/extensions))

The `az deployment group create` command has two parameters, `--debug` and `--verbose` that return more detailed information about the deployment.

## Roadmap

- Configurable port for grafana-server
- Option to upload and set up https certs and keys
- LDAP Configuration
- Default Azure monitoring dashboards
- Configure the ability to install additional plugins
- Allow user to select grafana version
- SQL backend integration
