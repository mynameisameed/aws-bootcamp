#!/usr/bin/env bash

# awscli
cd /workspaces/aws-bootcamp-cruddur-2023/ 
sudo apt install -y

# npm install  frontend
cd /workspaces/aws-bootcamp-cruddur-2023/frontend-react-js && npm update -g && npm i;

# backend pip requirements
cd /workspaces/aws-bootcamp-cruddur-2023/backend-flask && pip3 install -r requirements.txt;

# Postgresql
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" |sudo tee  /etc/apt/sources.list.d/pgdg.list';
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -;
sudo apt update -y
sudo apt install -y postgresql-client-13 libpq-dev
