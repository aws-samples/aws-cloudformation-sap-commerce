#!/bin/bash
# SAP Commerce 1905 Bootstraping
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

echo "Set initial password.."
aws s3 sync s3://$SCRIPTS3BUCKET/$SCRIPTKEYPREFIX/$RECIPE $HYBRISDIR/installer/recipes/$RECIPE
sed -i  "s/nimda/$INITIALPASSWORD/g"  $HYBRISDIR/installer/recipes/$RECIPE/build.gradle

echo "Installing Java .."
cd $HYBRISDIR
curl -L -O https://github.com/SAP/SapMachine/releases/download/sapmachine-11.0.4/sapmachine-jdk-11.0.4-1.x86_64.rpm
yum -y install $HYBRISDIR/sapmachine-jdk-11.0.4-1.x86_64.rpm
rm $HYBRISDIR/sapmachine-jdk-11.0.4-1.x86_64.rpm

echo "Setting JAVA_HOME Variable.."
export JAVA_HOME=/usr/lib/jvm/sapmachine-11

echo "Java Version: "
java -version

echo "Start Hybris.."
$HYBRISDIR/installer/install.sh -r $RECIPE			
$HYBRISDIR/installer/install.sh -r $RECIPE initialize
$HYBRISDIR/installer/install.sh -r $RECIPE start &

# Check Database instance Status
if ps -ef | grep tomcat; then
    echo "SAP_COMMERCE_INSTALL|SUCCESS"
else
    echo "SAP_COMMERCE_INSTALL|FAILURE"
    exit 1
fi

#Cleanup installation directory
rm -Rf /root/install/

echo "Finished Bootstrapping"



