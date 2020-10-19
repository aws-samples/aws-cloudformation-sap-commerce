# SAP Commerce on AWS
This repository contains an example of how to deploy the on-premise version of SAP Commerce on AWS. You can use this script for development and demonstration purposes.

## Step 1. Download the SAP Commerce software and upload to an Amazon S3 bucket

Download the SAP Commerce software from SAP and place the files in an S3 bucket. For example,

```
s3://[S3 Bucket]/[S3 Software Folder]/CXCOM200500P_0-70004955.ZIP 
```

## Step 2. Download the Scripts in this Github Repository and upload to an Amazon S3 bucket

Download the script folder from Github repository and place the scripts in an S3 bucket. For example,

```
s3://[S3 Bucket]/[scripts]/
```

## Step 3. Prepare AWS account

If you don’t already have a AWS account, VPC, Security Group and IAM role. Follow the step-by-step instruction, to create an [AWS account]( https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/), [VPC]( https://docs.aws.amazon.com/vpc/latest/userguide/vpc-getting-started.html), [Security Group ](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html) and [IAM Role]( https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html).


## Step 4. Launch the stack

The quickest way to do this is using AWSCLI.

    $ aws cloudformation create-stack --region=<AWS region> --stack-name <stack name> --template-url <CFN template on S3> --parameters ParameterKey=InitialPassword,ParameterValue=<your initial password> ParameterKey=InstanceRoleSAP,ParameterValue=< the name of the instance role to be attached to your EC2 instance > ParameterKey=KeyPairName,ParameterValue=<your EC2 key pair> ParameterKey=LinuxAMIOS,ParameterValue=Amazon-Linux2-HVM ParameterKey=InstanceType,ParameterValue=m5.xlarge ParameterKey=PDatabaseHostName,ParameterValue=< your hostname > ParameterKey=PrivateSubnet1ID,ParameterValue=< your subnet ID > ParameterKey=Recipe,ParameterValue=< the SAP Commerce recipe, for example b2c_acc_plus >  ParameterKey=SWS3BucketName,ParameterValue=< S3 bucket hosting SAP Commerce Software > ParameterKey=Version,ParameterValue=2005 ParameterKey=SWS3KeyPrefix,ParameterValue=< S3 folder hosting SAP Commerce Software >  ParameterKey=CreateDocker,ParameterValue=False ParameterKey=ScriptsS3BucketName,ParameterValue=< S3 bucket hosting scripts in this Github >  ParameterKey=ScriptsS3KeyPrefix,ParameterValue=< S3 folder hosting scripts in this Github >  ParameterKey=SecurityGroupID,ParameterValue=< your security group ID >  ParameterKey=VPCID,ParameterValue=<your VPC ID> ParameterKey=OSImageOverride,ParameterValue=< your custom AMI if needed > --on-failure DO_NOTHING --capabilities CAPABILITY_IAM

| Parameter | Description | Example Value | 
|---------|-------------|-------------|
|AWS region| Any AWS region | us-east-1 |
|Stack name| Name of the cloudformation stack| sap-commerce |
|CFN template on S3|  





### Step 5. Access SAP Commerce to verify your deployment

You can access SAP Commerce by IP address and the default port 9002 via your web browser 

### Step 6. Complete any post-deployment tasks

Before you start using SAP Commerce on AWS, change the initial password and make sure that your system is backed up and configured correctly. Refer to the [SAP Commerce on AWS blog](https://aws.amazon.com/blogs/awsforsap/driving-new-levels-of-agility-for-your-sap-workloads-an-example-with-sap-commerce/) on how you can leverage Amazon Aurora Serverless and Amazon EC2 Hibernation for SAP Commerce on AWS. THe JDBC driver for Amazon Aurora can be downloaded [here](https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.19.zip). 

# License

This library is licensed under the Apache 2.0 License.

