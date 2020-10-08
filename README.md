# SAP Commerce on AWS
## Introduction

This solution deploys the on-premise version of SAP Commerce on AWS. By deploying this solution on the AWS Cloud, you can take advantage of the fully managed services along with the flexibility to tailor the architecture choices for your infrastructure. 

## Deployment Guide

This CloudFormation template helps you rapidly deploy an SAP Commerce system on an EC2 instance for demo and development. Please note that this is not designed for production. This cloudformation use the SAP installer recipes included with SAP Commerce to set up a preconfigured environment quickly using the default HSQLDB.  

### Step 1. Prepare an AWS account
- [ ] This involves signing up for an AWS account, choosing a region, VPC, security group and an IAM role for Amazon EC2. If you don't already have an      AWS account. Follow the step-by-step instruction, see the [AWS account deployment guide]( https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/).
- [ ] Use the region selector in the navigation bar to choose the AWS Region where you want to deploy SAP Commerce on AWS. 
- [ ] If you don’t already have an AWS VPC. Follow the step-by-step instruction, see the [AWS VPC deployment guide]( https://docs.aws.amazon.com/vpc/latest/userguide/vpc-getting-started.html).
- [ ] Create an AWS Security Group for SAP Commerce. You will need to open the default  port 9002 to access SAP Commerce. Follow the step-by-step instruction, see the [AWS Security Group deployment guide](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html).
- [ ] Create an AWS IAM Role for Amazon EC2 with policy to access your S3 bucket and enable AWS system manager. Follow the step-by-step instruction, see the [AWS IAM Role for EC2 deployment guide]( https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html). 

### Step 2. Download the SAP Commerce software and upload to an Amazon S3 bucket

This step involves downloading the SAP Commerce software (1905 or 2005) from SAP and placing the files in an S3 bucket.  

For example, if you have s3://[S3 Bucket]/[binaries]/CXCOM200500P_0-70004955.ZIP

- [ ] The parameter "S3 Bucket Name for SAP Commerce Software" is the S3 bucket name, i.e. [S3 Bucket]

- [ ] The parameter "S3 Key Prefix for SAP Commerce 1905 Software" is the folder within the S3 bucket, i.e. [binaries]

### Step 3. Download the Scripts in this Github Repository and upload to an Amazon S3 bucket

This step involves downloading this Github repository and placing the files in an S3 bucket. 

For example, if you have s3://[S3 Bucket]/[scripts]/

- [ ] The parameter "S3 Bucket Name for Installation" is the S3 bucket name, i.e. [S3 Bucket]

- [ ] The parameter "ScriptsS3KeyPrefix" is the folder within the S3 bucket, i.e. [scripts]

### Step 4. Launch the stack

In this step, you’ll launch the AWS CloudFormation template into your AWS account, specify parameter values, and create the stack. 

- [ ] The parameter "InstanceRoleSAP" is the name for the IAM role that will be attached to the EC2 instance. 

The quickest way to do this is using AWSCLI, an example input parameters are shown below. 

aws cloudformation create-stack --region=< your region > --stack-name < stack name > --template-url < S3 bucket hosting the cloudformation template > --parameters ParameterKey=InitialPassword,ParameterValue=< your initial password > ParameterKey=InstanceRoleSAP,ParameterValue=s< the name of the instance role to be attached to your EC2 instance > ParameterKey=KeyPairName,ParameterValue=< your key pair > ParameterKey=LinuxAMIOS,ParameterValue=Amazon-Linux2-HVM ParameterKey=InstanceType,ParameterValue=m5.xlarge ParameterKey=PDatabaseHostName,ParameterValue=< your hostname > ParameterKey=PrivateSubnet1ID,ParameterValue=< your subnet ID > ParameterKey=Recipe,ParameterValue=< the SAP Commerce recipe, for example b2c_acc_plus >  ParameterKey=SWS3BucketName,ParameterValue=< S3 bucket hosting SAP Commerce Software > ParameterKey=Version,ParameterValue=2005 ParameterKey=SWS3KeyPrefix,ParameterValue=< S3 folder hosting SAP Commerce Software >  ParameterKey=CreateDocker,ParameterValue=False ParameterKey=ScriptsS3BucketName,ParameterValue=< S3 bucket hosting scripts in this Github >  ParameterKey=ScriptsS3KeyPrefix,ParameterValue=< S3 folder hosting scripts in this Github >  ParameterKey=SecurityGroupID,ParameterValue=< your security group ID >  ParameterKey=VPCID,ParameterValue=< your VPC ID > ParameterKey=OSImageOverride,ParameterValue=< your custom AMI if needed > --on-failure DO_NOTHING --capabilities CAPABILITY_IAM

### Step 5. Access SAP Commerce to verify your deployment

You can access SAP Commerce by IP address and the default port 9002 via your web browser 

### Step 6. Complete any post-deployment tasks

Before you start using SAP Commerce on AWS, change the initial password and make sure that your system is backed up and configured correctly. Refer to the [SAP Commerce on AWS blog](https://aws.amazon.com/blogs/awsforsap/driving-new-levels-of-agility-for-your-sap-workloads-an-example-with-sap-commerce/) on how you can leverage Amazon Aurora Serverless and Amazon EC2 Hibernation for SAP Commerce on AWS. THe JDBC driver for Amazon Aurora can be downloaded [here](https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.19.zip). 
