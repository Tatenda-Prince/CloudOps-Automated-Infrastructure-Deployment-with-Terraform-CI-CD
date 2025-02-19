# CloudOps Automated Infrastructure Deployment with Terraform & CI/CD

## Technical Architecture

![image_alt]()


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


   

