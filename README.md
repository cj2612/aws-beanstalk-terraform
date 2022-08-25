# Qiibee assignment 
## aws-elastic-beanstalk-environment - Haris Rasidagic
Terraform configuration files for AWS Beanstalk with GitHub actions.



## Description

This repo contains a demo AWS Beanstalk deployment using Terraform and GitHub actions. The goal is to showcase AWS and Terraform knowledge. 

> **_NOTE:_**  I was not able to use a real AWS account to perform tests of my configuration files due to the account being suspended (my friend's account, we can discuss this during my demo). Also, as communicated with Betania, Docker set a rate-limit for my IP address, thus not enabling me to use a private repo but rather public ones.

> **_NOTE:_**  I am open to discuss the provided solutions if you may have any questions. 

## Running the scripts

GitHub actions is currently setup to trigger on pushed to "main" branch and "opened" or "reopened" pull requests. 

However, it will no run properly until the following requirements are fulfilled: 

1. Add **AWS_ACCESS_KEY** and **AWS_SECRET_KEY** as repository secrets with Actions secrets. These are required for authentication to AWS and are called within *provider.tf*.
2. Insert the port your BeanStalk app will be listening on and the expected HTTP response by the ELB by editing environment variables **TF_VAR_APP_PORT** and **TF_VAR_APP_HTTP_RESPONSE** in *./github/workflows/terraform.yml*. 
Example below:
```
  TF_VAR_APP_HTTP_RESPONSE: 304
  TF_VAR_APP_PORT: 8080

  # aws region can be changed as well
  TF_VAR_AWS_REGION: "eu-central-1"
```

## Docker configuration
Moving on, the current Docker configuration for Beanstalk is setup to use a *Dockerfile*. 

Terraform will automatically insert the Dockerfile you insert in the root of this repo into a s3 bucket and use it for the beanstalk app version.

Therefore, please insert your Dockerfile into the root of this repo, expose the correct ports and match them with the value set in **TF_VAR_APP_PORT** env variable.

If you wish to change Docker configuration and use a different deployment method please refer to: https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/single-container-docker-configuration.html


## Disclosure 
Unfortunately, due to my obligations at my current job I was unable to put aside enough time to fully complete the assignment. I hope you will take this into consideration. I am happy to discuss how the unfinished tasks would be solved and what my suggestions would be. Also, as you can see this task required pre-configuring a VPC network with public and private subnets which was not taken into consideration and resulted in more work. I did not want to use existing modules available in order to showcase Terraform and AWS knowledge in a bit more authentic way :) 