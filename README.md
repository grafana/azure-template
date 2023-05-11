# Grafana Azure Marketplace Offer

This is the template and scripts for producing the [OSS Azure Marketplace Offer for Grafana](https://azuremarketplace.microsoft.com/en-gb/marketplace/apps/grafana-labs.grafana_oss?tab=Overview).

## Development

For an introduction to create Azure Marketplace offers, you should read
[this article](https://docs.microsoft.com/en-us/azure/marketplace/partner-center-portal/create-new-azure-apps-offer).

### API Reference

Read the main Azure Resource Manager (AKA ARM) template
[reference](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-syntax)
in order to understand how to write mainTemplate.json (an ARM template). To
understand how to declare resources in your template, see the resource
[reference](https://docs.microsoft.com/en-us/azure/templates/).

## Publishing the marketplace offering

High level steps:

1. Update the version number
1. Validate the offer
1. Upload to the Azure Marketplace Partner Portal and publish

### 1. Update the version number

1. Update the `GRAFANA_VERSION` command line option to the latest version of Grafana in the `scripts/install-grafana.sh` file.
1. Update the `githubUsername` and `dateUpdated` fields in the `metadata.json` field.
1. Commit the change to Git.

### 2. Validate the offer

In order to validate mainTemplate.json, you can use the
[Azure CLI](https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest)
command `az` as follows:

1. Validate the template

   Create a resource group.

   ```bash
   az login

   az group create --name mktplacetest --location "westcentralus"

   # We must set the _artifactsLocation parameter since for some reason the
   # default won't work when validating
   az deployment group validate -g mktplacetest -f mainTemplate.json \
   -p _artifactsLocation=https://github.com/grafana/azure-template/tree/master/
   ```

   It will ask for parameters. See the parameter section below for the values that should be filled in.

1. Push your branch to GitHub.
1. Test the install script
   Deploy the template to Azure with the command below.

   - Change `yourbranch` to the name of the branch that you pushed to GitHub in the previous step.
   - The `_artifactsLocation` parameter has to have a trailing slash.
   - Use the same name (`mktplacetest`) that you used for the group create command.

   ```bash
   az deployment group create -g mktplacetest -f mainTemplate.json -p _artifactsLocation=https://raw.githubusercontent.com/grafana/azure-template/yourbranch/ -p sshPassword=a_Passw0rd
   ```

   A list of parameters needs to be filled in:

   - `sshUsername` is the username for ssh-ing into the VM that is created. E.g. `ssh daniel@mktplacetest.westcentralus.cloudapp.azure.com`.
   - `grafanaAdminPassword` is the initial admin password for Grafana at `http://mktplacetest.westcentralus.cloudapp.azure.com:3000`.

   For the rest of the parameters, enter the same name as the resource group that you created previously with the `az group create` command e.g. `mktplacetest`.

   - `publicIPAddressName` - the deployment will create a public IP address.
   - `domainNamePrefix` - used for the first part of the url when the deployment creates a DNS name.
   - `storageAccountName`- the deployment will create a [storage account](https://portal.azure.com/#blade/HubsExtension/BrowseResource/resourceType/Microsoft.Storage%2FStorageAccounts).
   - `virtualNetworkName` - the deployment will create a virtual network.

1. Log into the Grafana instance: http://mktplacetest.westcentralus.cloudapp.azure.com:3000 with user `admin` and the `grafanaAdminPassword` from the previous step.
1. Cleanup

   ```bash
   az group delete --name mktplacetest
   ```

#### Troubleshooting

If the last step of the deployment fails, you can ssh into the VM to troubleshoot with the username and password that you specified above. There are some log files that you can check. Details [here](https://github.com/Azure/custom-script-extension-linux#3-troubleshooting).

The VM extension for the script can be found in the portal under extensions ([here for the staging VM](https://portal.azure.com/#@grafana.com/resource/subscriptions/44693801-6ee6-49de-9b2d-9106972f9572/resourceGroups/grafanastaging/providers/Microsoft.Compute/virtualMachines/grafana/extensions))

The `az deployment group create` command has two parameters, `--debug` and `--verbose` that return more detailed information about the deployment.

### 3. Upload to the Azure Marketplace Partner Portal and publish

1. Get access to the Grafana Azure portal and then ask Daniel Lee or Dan Cech for access to the Azure Marketplace Partner Portal.
2. Build the zip file to upload by running `./build.sh`
3. Navigate to the technical configuration section of the Grafana plan: https://partner.microsoft.com/en-us/dashboard/commercial-marketplace/offers/b88530aa-30f9-40ea-b09f-14f59acd3a73/plans/2118022800000041745/technicalconfiguration
4. Update the version number to the Grafana version. Remove the zip file and upload the new `./build/grafana-azure.zip`.
5. Click `Save draft`.
6. Click `Review and publish`.
7. Click `Publish`.
8. Wait a few minutes (up to an hour) for the Preview creation to complete then navigate to: https://partner.microsoft.com/en-us/dashboard/commercial-marketplace/offers/b88530aa-30f9-40ea-b09f-14f59acd3a73/overview and click `Go live`.
9. Check the automatic PR created: https://solutiontemplates.visualstudio.com/marketplacesolutions/_git/grafana-labs/pullrequests?_a=mine to see if it passes the linting in the build.

## Roadmap

- Configurable port for grafana-server
- Option to upload and set up https certs and keys
- LDAP Configuration
- Default Azure monitoring dashboards
- Configure the ability to install additional plugins
- Allow user to select grafana version
- SQL backend integration
