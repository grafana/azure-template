#!/bin/bash

# Utility Log Command
log()
{
    echo "`date -u +'%Y-%m-%d %H:%M:%S'`: ${1}"
}

# Parameters

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

install_grafana
start_grafana
