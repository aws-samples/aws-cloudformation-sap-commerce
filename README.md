# SAP Commerce on AWS
## Introduction

This solution deploys the on-premise version of SAP Commerce on AWS. By deploying this solution on the AWS Cloud, you can take advantage of the fully managed services along with the flexibility to tailor the architecture choices for your infrastructure. 

## Deployment Guide

This CloudFormation template helps you rapidly deploy an SAP Commerce system on an EC2 instance for demo and development. Please note that this is not designed for production. This cloudformation use the SAP installer recipes included with SAP Commerce to set up a preconfigured environment quickly using the default HSQLDB.  

Step 1. Prepare an AWS account
1. This involves signing up for an AWS account, choosing a region, VPC, security group and an IAM role for Amazon EC2. If you don't already have an AWS account. Follow the step-by-step instruction, see the [AWS account deployment guide]( https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/).
2. Use the region selector in the navigation bar to choose the AWS Region where you want to deploy SAP Commerce on AWS. 
3. If you don’t already have an AWS VPC. Follow the step-by-step instruction, see the [AWS VPC deployment guide]( https://docs.aws.amazon.com/vpc/latest/userguide/vpc-getting-started.html).
4.	Create an AWS Security Group for SAP Commerce. You will need to open the default  port 9002 to access SAP Commerce. Follow the step-by-step instruction, see the [AWS Security Group deployment guide](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html).
5.	Create an AWS IAM Role for Amazon EC2 with policy to access your S3 bucket and enable AWS system manager. Follow the step-by-step instruction, see the [AWS IAM Role for EC2 deployment guide]( https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html). 

Step 2. Download the SAP Commerce software

This step involves downloading the SAP Commerce software (1905 or 2005) from SAP and placing the files in an S3 bucket.  

For example, if you have s3://[S3 Bucket]/[Binaries]/CXCOM200500P_0-70004955.ZIP

- [x] The parameter SWS3BucketName is the S3 bucket name [S3 Bucket]

- [x] The parameter SWS3KeyPrefix is the S3 bucket folder [Binaries]

Step 3. Launch the stack

In this step, you’ll launch the AWS CloudFormation template into your AWS account, specify parameter values, and create the stack. 

Step 4. Access SAP Commerce to verify your deployment

You can access SAP Commerce by IP address and the default port 9002 via your web browser 

Step 5. Complete any post-deployment tasks

Before you start using SAP Commerce on AWS, change the initial password and make sure that your system is backed up and configured correctly. Refer to the [SAP Commerce on AWS blog](https://aws.amazon.com/blogs/awsforsap/driving-new-levels-of-agility-for-your-sap-workloads-an-example-with-sap-commerce/) on how you can leverage Amazon Aurora Serverless and Amazon EC2 Hibernation for SAP Commerce on AWS. 
