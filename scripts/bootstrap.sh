#!/bin/bash
# SAP Commerce 1905 or 2005 Bootstraping (Developer Edition)
# This script is written for the AWS blog post is not design for production use 
# Author : patleung@amazon.com

################ Functions ################ 
function checkos() {
    platform='unknown'
    unamestr=`uname`
    if [[ "${unamestr}" == 'Linux' ]]; then
        platform='linux'
    else
        echo "[WARNING] This script is not supported on MacOS or freebsd"
        exit 1
    fi
}

function usage() {
echo "$0 <usage>"
echo " "
echo "options:"
echo -e "-h, --help \t show options for this script"
echo -e "-v, --verbose \t specify to print out verbose bootstrap info"
echo -e "--params_file \t specify the params_file to read (--params_file /root/install/sap-setup.txt)"
echo -e "--primary \t specify for primary host"
echo -e "--standby \t specify for standby host"
}
################ Functions ################ 

################ Start Script Logic ################ 
checkos

ARGS=`getopt -o hv -l help,verbose,params_file:,primary,standby -n $0 -- "$@"`
eval set -- "${ARGS}"

if [ $# == 1 ]; then
    echo "No input provided! type ($0 --help) to see usage help" >&2
    exit 2
fi

# extract options and their arguments into variables.
while true; do
    case "$1" in
        -v|--verbose)
            echo "[] DEBUG = ON"
            VERBOSE=true;
            shift
            ;;
        --params_file)
            echo "[] PARAMS_FILE = $2"
            PARAMS_FILE="$2";
            shift 2
            ;;
        --primary)
            echo "[] HOST_TYPE = PRIMARY"
            HOST_TYPE='PRIMARY';
            shift
            ;;
        --standby)
            echo "[] HOST_TYPE = STANDBY"
            HOST_TYPE='STANDBY';
            shift
            ;;
        --)
            break
            ;;
        *)
            break
            ;;
    esac
done

if [ -f ${PARAMS_FILE} ]; then
    SWS3BUCKET=`grep 'SWS3BucketName' ${PARAMS_FILE} | awk -F'|' '{print $2}' | sed -e 's/^ *//g;s/ *$//g'`
    SWS3KEYPREFIX=`grep 'SWS3KeyPrefix' ${PARAMS_FILE} | awk -F'|' '{print $2}' | sed -e 's/^ *//g;s/ *$//g'`
    SCRIPTS3BUCKET=`grep 'ScriptsS3BucketName' ${PARAMS_FILE} | awk -F'|' '{print $2}' | sed -e 's/^ *//g;s/ *$//g'`
    SCRIPTKEYPREFIX=`grep 'ScriptsS3KeyPrefix' ${PARAMS_FILE} | awk -F'|' '{print $2}' | sed -e 's/^ *//g;s/ *$//g'`
    INITIALPASSWORD=`grep 'InitialPassword' ${PARAMS_FILE} | awk -F'|' '{print $2}' | sed -e 's/^ *//g;s/ *$//g' | sed 's/\/$//g'`
    RECIPE=`grep 'Recipe' ${PARAMS_FILE} | awk -F'|' '{print $2}' | sed -e 's/^ *//g;s/ *$//g'`
    PHOSTNAME=`grep 'PDatabaseHostName' ${PARAMS_FILE} | awk -F'|' '{print $2}' | sed -e 's/^ *//g;s/ *$//g'`
    VERSION=`grep 'Version' ${PARAMS_FILE} | awk -F'|' '{print $2}' | sed -e 's/^ *//g;s/ *$//g'`
    DOCKER=`grep 'CreateDocker' ${PARAMS_FILE} | awk -F'|' '{print $2}' | sed -e 's/^ *//g;s/ *$//g'`

else
    echo "Paramaters file not found or accessible."
    exit 1
fi

if [[ ${VERBOSE} == 'true' ]]; then
    echo "SWS3BUCKET = ${SWS3BUCKET}"
    echo "SWS3KEYPREFIX = ${SWS3KEYPREFIX}"
    echo "SCRIPTKEYPREFIX = ${SCRIPTKEYPREFIX}"
    echo "SCRIPTS3BUCKET = ${SCRIPTS3BUCKET}"
    echo "INITIALPASSWORD = ${INITIALPASSWORD}"
    echo "RECIPE = ${RECIPE}"
fi


echo "Set Hybris directory..."
HYBRISDIR=/usr/sap

echo "Set hostname..."
hostname $PHOSTNAME
echo $PHOSTNAME > /etc/hostname

echo "Installing Unzip..."
yum -y install unzip

echo "Creating Hybris home directory..."
mkdir $HYBRISDIR
cd $HYBRISDIR

echo "Download Hybris software from S3 bucket..."
aws s3 sync s3://$SWS3BUCKET/$SWS3KEYPREFIX $HYBRISDIR
unzip $HYBRISDIR/*.ZIP

echo "Removing the Hybris Installation zip file.."
rm $HYBRISDIR/*.ZIP

echo $VERSION

echo "Installing Java .."
cd $HYBRISDIR
curl -L -O https://github.com/SAP/SapMachine/releases/download/sapmachine-11.0.4/sapmachine-jdk-11.0.4-1.x86_64.rpm
yum -y install $HYBRISDIR/sapmachine-jdk-11.0.4-1.x86_64.rpm
rm $HYBRISDIR/sapmachine-jdk-11.0.4-1.x86_64.rpm

echo "Setting JAVA_HOME Variable.."
export JAVA_HOME=/usr/lib/jvm/sapmachine-11

echo "Java Version: "
java -version

echo "Setup SAP Commerce"

if [ "$VERSION" = 1905 ]
then
    echo "set up recipe for 1905 and password"
    aws s3 sync s3://$SCRIPTS3BUCKET/$SCRIPTKEYPREFIX/$RECIPE $HYBRISDIR/installer/recipes/$RECIPE
    sed -i  "s/nimda/$INITIALPASSWORD/g"  $HYBRISDIR/installer/recipes/$RECIPE/build.gradle
    $HYBRISDIR/installer/install.sh -r $RECIPE initialize
else
    echo "set up recipe for 2005 and password"
    aws s3 sync s3://$SCRIPTS3BUCKET/$SCRIPTKEYPREFIX/$RECIPE $HYBRISDIR/installer/recipes/$RECIPE
    $HYBRISDIR/installer/install.sh -r $RECIPE -A initAdminPassword=$INITIALPASSWORD
    $HYBRISDIR/installer/install.sh -r $RECIPE	initialize -A initAdminPassword=$INITIALPASSWORD
fi

# Creating docker image
if [ "$DOCKER" = True ]
then
    echo "Build Docker image"

    cd $HYBRISDIR/hybris/bin/platform/
    . $HYBRISDIR/hybris/bin/platform/setantenv.sh     

    ant clean all

    ant production -Dproduction.include.tomcat=false -Dproduction.legacy.mode=false -Dtomcat.legacy.deployment=false -Dproduction.create.zip=false

    ant createPlatformImageStructure

    #Enable HTTP connection#

    aws s3 cp s3://$SCRIPTS3BUCKET/$SCRIPTKEYPREFIX/server.xml $HYBRISDIR/hybris/temp/hybris/platformimage-*/aspects/default/tomcat/conf/server.xml
    aws s3 cp s3://$SCRIPTS3BUCKET/$SCRIPTKEYPREFIX/Dockerfile $HYBRISDIR/hybris/temp/hybris/platformimage-*/
    cp $HYBRISDIR/hybris/bin/platform/tomcat/lib/keystore $HYBRISDIR/hybris/temp/hybris/platformimage-*/

    echo "Start Docker"
    amazon-linux-extras install docker -y
    yum install jq -y

    service docker start

    echo "Create Docker Image"

    cd /usr/sap/hybris/temp/hybris/platformimage-*

    REPO=sap-commerce-repo
    AWS_ACCOUNT=$(curl http://169.254.169.254/latest/meta-data/identity-credentials/ec2/info | jq -r .AccountId)
    REGION=$(curl http://169.254.169.254/latest/meta-data/placement/region)

    docker build -t $REPO .

    echo "Create ECR repository"

    aws ecr create-repository --repository-name $REPO --region $REGION

    docker tag $REPO:latest $AWS_ACCOUNT.dkr.ecr.$REGION.amazonaws.com/$REPO:latest

    aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT.dkr.ecr.$REGION.amazonaws.com

    echo "Push Image to Amazon ECR"

    docker push $AWS_ACCOUNT.dkr.ecr.$REGION.amazonaws.com/$REPO:latest

fi

# Start Hybris

echo "Start Hybris.."
$HYBRISDIR/installer/install.sh -r $RECIPE start &

# Check Tomcat Status
if ps -ef | grep tomcat; then
    echo "SAP_COMMERCE_INSTALL|SUCCESS"
else
    echo "SAP_COMMERCE_INSTALL|FAILURE"
    exit 1
fi

#Cleanup installation directory
#rm -Rf /root/install/

echo "Finished Bootstrapping"