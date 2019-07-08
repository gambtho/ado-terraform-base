# **Terraform - Deployment pipeline**

This repo is meant as a template for starting Azure DevOps deployments using terraform. The process is orchestrated through **Azure DevOps (ADO) pipelines**. The provided shell scripts will create a storage account to keep the terraform remote state. 

## Setup the Azure DevOps environment

Follow the step below to setup your environment prior to runnig the Azure DevOps pipelines.

1. Create an Azure **Service connection** in ADO.

2. Create a **Variable group** in the ADO pipeline library with the following variables:
    - azureSub (should be set to the name of the connection created above)
    - cluster_name (only use small caps and no special characters)
    - env

3. Add **terraform.tfvars** as a Secure file in the pipeline library and make sure to select the checkbox "Authorize for use in all pipelines". The following variables must be set in this file, where the ARM variables can be created following these [instructions](https://www.terraform.io/docs/providers/azurerm/auth/service_principal_client_secret.html).  A template is available at empty.auto.tfvars

    ```bash
    ARM_CLIENT_ID=""
    ARM_CLIENT_SECRET=""
    ```

You can now create a build pipeline using the azure-pipelines.yml  . If successfull, a release pipeline can then be created that makes use of the artifacts created by the build pipeline.  This pipeline should use the apply.sh script from this repo.

## Usage

Use the following commands if you want to run the project locally instead of running it through the Azure DevOps pipelines.

  ```bash
  export TF-ENV=someenv
  export TF-PROJECT=someproject
  ./init.sh -a ${TF-ENV}${TF-PROJECT} -e ${TF-ENV} -g ${TF-ENV}${TF-PROJECT}
  ./plan.sh -a ${TF-ENV}${TF-PROJECT} -e ${TF-ENV} -g ${TF-ENV}${TF-PROJECT}
  ./apply.sh -e ${TF-ENV}
  ```

## Contributions

This repo is a work in progress, pull requests and suggestions are greatly appreciated

## Maintainers

Thomas Gamble 
