# Deploying To Azure

## Introduction

This document aims to provide a step-by-step guide to deploying this
application to Azure using Kamal 2.0. Since this application is using Rails 7.2 since
the writing of this document, the codebase lacks some required configuration
changes included in Rails 8 by default. Furthermore, Azure is a bit different
and requires some considerations not explicitly mentioned in the documentation.

This guide focuses just deploying the application to a single VM instance on Azure.
It doesn't cover setting up the database on the same VM instance or anything
else. For this guide we are going to setup a domain to point to a Azure
VM running the application with SSL + a external database also hosted
on Azure.

## Prerequisites

Here are some key things you need before starting this guide and why:

- Dockerhub account: You need this to store the Docker image of the application between
deployments
- Azure Account: You need this to create the VM instance and the database.
- `production.key`: Needed to decrypt the credentials in the production
environment which contain the kamal secrets. Ask leads for this file
if you don't have it.

## Step 1: Initial Kamal Setup

First, you need to setup Kamal on your local machine. You can follow the guide
[here](https://kamal-deploy.org/docs/installation/) here. You should have the
`kamal` command and all extra files needed for deployment. Notably, you'll be
modifying just two files `config/deploy.yml` and `.kamal/secrets` in the project.

### Step 1.1: Setup `config/deploy.yml`

You will need to do a few modifications here to make sure the deployment works


- Change the `service`, `app_name`, and `servers` to match the application's name
```
# Name of your application. Used to uniquely configure containers.
service: homeward-tails # Name of the application.

# Name of the container image.
image: edwinthinks/homeward-tails

# Deploy to these servers.
servers:
  web:
    - tails.edwinmak.com
```


## Step 2: Setup Azure
