# CloudOps Automated Infrastructure Deployment with Terraform & CI/CD

## Technical Architecture

![image_alt](https://github.com/Tatenda-Prince/terraform-aws-cicd/blob/af892a51ef107bd632bcd3192765e641db159a8e/img/Screenshot%202025-02-19%20165839.png)


## Project Overview

This project demonstrates how to create a CI/CD pipeline for AWS infrastructure deployment using Terraform and GitHub Actions. It uses GitHub Actions to automate deployment and sets up an EC2 instance, S3 bucket, IAM roles, and security groups.

## Technologies Used

1.Terraform – Infrastructure as Code (IaC)

2.AWS – EC2, S3, IAM, Security Groups

3.GitHub Actions – CI/CD automation

4.Node.js – Simple app deployment on EC2


## Features

1.Infrastructure as Code using Terraform

2.Automated deployment with GitHub Actions

3.Secure AWS resource provisioning

4.Node.js app deployment via EC2 user data

5.Fully automated CI/CD pipeline


## Project Setup & Deployment

## Terraform Code for AWS Infrastructure

The Terraform scripts provision:

1.1.EC2 Instance (to host the Node.js app)

1.2.S3 Bucket (for storage)

1.3.IAM Roles & Policies (for security and access control)

1.4.Security Groups (to manage inbound/outbound traffic)


## Deploy a Node.js App on EC2

Using EC2 user data, the instance will:

2.1.Install Node.js and dependencies

2.2.Clone the application repository

2.3.Start the application automatically


## Set Up GitHub Actions for CI/CD

3.1.Terraform Plan & Apply on push to main

3.2.Automated deployment to AWS

3.4.gitignore and GitHub Actions YAML configured for security


## Test & Validate

4.1.Push code changes to GitHub

4.2.Verify AWS infrastructure deployment

4.3.Ensure Node.js app is running on EC2


## Step 1: Clone the Repository

1.1.Clone this repository to your local machine

```language
git clone https://github.com/Tatenda-Prince/terraform-aws-cicd.git
```

We are going first to run our terraform manually locally before we use GitHub Actions to automate our infrastructure just to check if we don't have any errors.


## Step 2 : Run Terraform workflow to initialize, validate, plan then apply

2.1.In your local terraform visual code environment terminal, to initialize the necessary providers, execute the following command in your environment terminal —

```language
terraform init
```
Upon completion of the initialization process, a successful prompt will be displayed, as shown below.

![image_alt](https://github.com/Tatenda-Prince/terraform-aws-cicd/blob/a71ab5b28533bacc3f1891eaea15f367750d34a7/img/Screenshot%202025-02-19%20151927.png)


2.2.Next, let’s ensure that our code does not contain any syntax errors by running the following command —


```language
terraform validate
```

The command should generate a success message, confirming that it is valid, as demonstrated below.

![image_alt](https://github.com/Tatenda-Prince/terraform-aws-cicd/blob/fa860339f5f4a96b7cd014e2c28dfb0b4a4955c6/img/Screenshot%202025-02-19%20152020.png)

2.3.Let’s now execute the following command to generate a list of all the modifications that Terraform will apply. —


```language
terraform plan
```

![image_alt](https://github.com/Tatenda-Prince/terraform-aws-cicd/blob/642512de8fb352865f29e9f283653ceefe9d7c1c/img/Screenshot%202025-02-19%20152205.png)


The list of changes that Terraform is anticipated to apply to the infrastructure resources should be displayed. The “+” sign indicates what will be added, while the “-” sign indicates what will be removed.

2.4.Now, let’s deploy this infrastructure! Execute the following command to apply the changes and deploy the resources.

Note — Make sure to type “yes” to agree to the changes after running this command


```language
terraform apply
```

Terraform will initiate the process of applying all the changes to the infrastructure. Kindly wait for a few seconds for the deployment process to complete.

![image_alt](https://github.com/Tatenda-Prince/terraform-aws-cicd/blob/d2ed3db932708053ff1f45d878c4458abf3aea08/img/Screenshot%202025-02-19%20152532.png)

## Success!

The process should now conclude with a message indicating “Apply complete”, stating the total number of added, modified, and destroyed resources, accompanied by several resources.

![image_alt](https://github.com/Tatenda-Prince/terraform-aws-cicd/blob/7e56b06480851e8ab4c630afd390f6ff61b37517/img/Screenshot%202025-02-19%20153101.png)


## Step 3: Verify if The EC2 instance is running a Node.js app

3.1.In the AWS Management Console, head to the Amazon EC2 dashboard and verify that the instance  was successfully created.

![image_alt](https://github.com/Tatenda-Prince/terraform-aws-cicd/blob/5ff47f4a767d04978cef9623e3f1679799ee48c5/img/Screenshot%202025-02-19%20153156.png)

3.2.Now lets test the Node.js app.find the EC2 Public IP from Terraform output and open in a browser:

```language
http://<EC2_PUBLIC_IP>:3000

```

![image_alt](https://github.com/Tatenda-Prince/terraform-aws-cicd/blob/00b876f04fda5d29856fb8d68ff34cabe901179f/img/Screenshot%202025-02-19%20153232.png)

Our Node.js is Successfully running. 


## Step 4: Lets Configure GitHub Actions for Automation

4.We'll create a GitHub Actions workflow to:

Initialize Terraform (`terraform init`)

Plan changes (`terraform plan`)

Apply changes automatically (`terraform apply`)

4.1.Create a `.github/workflows` Directory

Inside your project repository, create a new directory:

```language
mkdir -p .github/workflows
```

4.2. Create `terraform-ci-cd.ym`l File

Now, inside `.github/workflows/`, create a new file called `terraform-ci-cd.yml`:

copy paste the yaml file below 


```yaml
name: Terraform AWS Deployment with Access Keys

on:
  push:
    branches:
      - master
  pull_request:
    branches:
      - master

permissions:
  contents: read

jobs:
  terraform:
    name: Terraform Apply
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.5.0

      - name: Configure AWS Credentials (Using GitHub Secrets)
        run: |
          mkdir -p ~/.aws
          echo "[default]" > ~/.aws/credentials
          echo "aws_access_key_id=${{ secrets.AWS_ACCESS_KEY_ID }}" >> ~/.aws/credentials
          echo "aws_secret_access_key=${{ secrets.AWS_SECRET_ACCESS_KEY }}" >> ~/.aws/credentials
          echo "region=us-east-1" > ~/.aws/config

      - name: Initialize Terraform
        run: terraform init

      - name: Terraform Plan
        run: terraform plan

      - name: Terraform Apply
        if: github.event_name == 'push'
        run: terraform apply -auto-approve
```

4.3.Add AWS Credentials to GitHub Secrets

4.3.1.To allow GitHub Actions to deploy to AWS securely, set up AWS Secrets:

4.3.2.Go to your GitHub repository.

4.3.3.Navigate to: `Settings` → `Secrets `and `variables `→ `Actions` → `New Repository Secret`.

Add:

`AWS_ACCESS_KEY_ID`

`AWS_SECRET_ACCESS_KEY`

4.4.Create the `.gitignore` File

This ensures that sensitive Terraform state files and temporary files are not tracked in Git.

```language
nano .gitignore
```

Then, paste the following content inside:

```language

# Terraform
.terraform/
*.tfstate
*.tfstate.backup

# Ignore sensitive files
terraform.tfvars
terraform.tfvars.json
*.auto.tfvars

# Ignore logs and temporary files
*.log
*.bak

# Ignore environment-specific configurations
.env
```

## Step 5: Let push the changes 

5.1 Now we will Commit and push your `.github/workflows/terraform-ci-cd.yml` file to GitHub:

```language
git add .github/workflows/terraform-ci-cd.yml

git commit -m "Add GitHub Actions workflow for Terraform"

git push origin master
```


5.2 This will trigger a Workflow 

After pushing the code:

Navigate to GitHub → Actions Tab in your repository.

![iamge_alt](https://github.com/Tatenda-Prince/terraform-aws-cicd/blob/9505eaae16347c175bedc31be19436db9eade67d/img/Screenshot%202025-02-19%20160728.png)


You should see your Terraform workflow running.

![image_alt](https://github.com/Tatenda-Prince/terraform-aws-cicd/blob/665f9e3c86342c68aaac28136c94e5782749dde8/img/Screenshot%202025-02-19%20160806.png)


Once complete, your AWS infrastructure should be deployed automatically!

![image_alt](https://github.com/Tatenda-Prince/terraform-aws-cicd/blob/5eeb9ed86b9cccd5a09867142bd358fdd4ffc830/img/Screenshot%202025-02-19%20160841.png)


## Step 6: Testing the CI/CD Pipeline by Updating the App

We'll make a small change to the Node.js app, push it to GitHub, and check if the pipeline automatically deploys the update.

6.1 Modify the Node.js App


6.1.1.Open the Terraform user_data script inside `main.tf`.

6.1.2.Find the echo command that creates `app.js`.

6.1.3.Change the message from

```language
js
"</h1>Hello, Welcome To Up The Chels Tech!<br>From Node.js App on EC2 Deployed Using GitHub Actions and Terraform!Your app has been updated</h1>
```

To

```language
js
"</h1>Hello, Welcome To Up The Chels Tech!<br>From Node.js App on EC2 Deployed Using GitHub Actions and Terraform!Your app has been updated!Your app has been updated</h1>
```


6.1.4.Save the file.


6.2.1.Commit and Push the Changes

we should run these commands:

```language
sh

git add main.tf

git commit -m "Update Node.js app message"

git push origin main
```

This will trigger GitHub Actions, which will run Terraform and update your EC2 instance.


6.2.2.Check the Deployment

6.2.3.Navigate  to GitHub → Actions tab and check if the workflow runs successfully.

Get the EC2 Public IP:

```language
sh
terraform output
```

Test the app in your browser:

```language
http://<EC2_PUBLIC_IP>:3000
```

![image_alt](https://github.com/Tatenda-Prince/terraform-aws-cicd/blob/1a827ff3549a7eb4fbf96c9aa11af0853f5bd231/img/Screenshot%202025-02-19%20162747.png)


## Future Enhancements


 1.Implement multi-environment (dev/staging/prod) deployment
 
 2.Add monitoring with AWS CloudWatch
 
 3.Automate rollbacks for failed deployments


 ## Congratulations

We successfully provisioned AWS resources using Terraform, including an EC2 instance for hosting a Node.js application, an S3 bucket for storage, and IAM roles with security groups for access control. The deployment process was fully automated using GitHub Actions, enabling continuous integration and deployment with secure authentication via AWS secrets (IAM Access Keys or OIDC). Finally, we tested the CI/CD pipeline by modifying the Node.js application, ensuring automatic deployment of updates and seamless infrastructure changes through Terraform.






































