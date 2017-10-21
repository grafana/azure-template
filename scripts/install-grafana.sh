#!/bin/bash

# Utility Log Command
log()
{
    echo "`date -u +'%Y-%m-%d %H:%M:%S'`: ${1}"
}

help()
{
    echo "This script installs Grafana cluster on Ubuntu"
    echo "Parameters:"
    echo "-A admin password"
    echo "-h view this help content"
}

# Parameters
ADMIN_PWD="admin"

#Loop through options passed
while getopts :A:h optname; do
  log "Option $optname set"
  case $optname in
    A)
      ADMIN_PWD="${OPTARG}"
      ;;
    h) #show help
      help
      exit 2
      ;;
    \?) #unrecognized option - show help
      echo -e \\n"Option -${BOLD}$OPTARG${NORM} not allowed."
      help
      exit 2
      ;;
  esac
done


# Command Line Opts


# Install Grafana
install_grafana()
{
    sudo apt-get install -y adduser libfontconfig
    wget https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana_4.5.2_amd64.deb
    sudo dpkg -i grafana_4.5.2_amd64.deb
    systemctl daemon-reload
}

start_grafana()
{
    systemctl start grafana-server
    sudo systemctl enable grafana-server.service
}

# Install the Azure Monitor Datasource
install_plugins()
{
    grafana-cli plugins install grafana-azure-monitor-datasource
    systemctl restart grafana-server
}

# Update the grafana passord of the admin account
configure_admin_password()
{   
    curl -X PUT -H "Content-Type: application/json" \
    -d "{\"oldPassword\": \"admin\", \"newPassword\": \"${ADMIN_PWD}\", \"confirmNew\": \"${ADMIN_PWD}\"}" \
    http://admin:admin@localhost:3000/api/user/password
}

install_grafana
start_grafana
configure_admin_password
install_plugins
