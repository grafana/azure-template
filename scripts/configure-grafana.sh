#!/bin/bash

# Utility Log Command
log()
{
    echo "`date -u +'%Y-%m-%d %H:%M:%S'`: ${1}"
}

update_password()
{
    curl -X PUT -H "Content-Type: application/json" -d \
    '{"oldPassword": "admin", "newPassword": "${1}", "confirmNew": "${$}"}' \
     http://admin:admin@localhost:3000/api/user/password
}