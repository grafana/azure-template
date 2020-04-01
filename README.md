# Grafana Azure Marketplace Offer

## Development

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
az deployment group validate -g azuremarketplacegrafana -f mainTemplate.json
```

## Roadmap

* Configurable port for grafana-server
* Option to upload and set up https certs and keys
* LDAP Configuration
* Default Azure monitoring dashboards
* Configure the ability to install additional plugins
* Allow user to select grafana version
* SQL backend integration
