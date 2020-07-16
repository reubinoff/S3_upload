#!/bin/bash

######################################################
#
# env var required: AWS_ACCESS_KEY AWS_SECRET REGION BUCKET
# args:
#   file_to_upload - which file to upload
#   s3_path - path at destenation
#   aws_cli_installation_required - If aws cli installation required. values: 1 (yes), 0 (no)
# run the script for example: ./upload_to_s3.sh /tmp/moshe.txt my_path/dst_folder 1
#
######################################################

echoerr()( echo $@|sed $'s,.*,\e[31m&\e[m,'>&2)3>&1
echok()( echo $@|sed $'s,.*,\e[32m&\e[m,'>&2)3>&1

# check env VARS
VARS=(AWS_ACCESS_KEY AWS_SECRET REGION BUCKET)
for _var in "${VARS[@]}";
do
    if [[ -z "${!_var}" ]]; then
        echoerr " enviroment var $_var doesnt exist"
        exit 1
    fi
done

# check args
if [ "$1" != "" ]; then
    file_to_upload=$1
else
    echoerr "Please specify full path to upload"
    exit 1
fi
if [ "$2" != "" ]; then
    s3_path=$2
else
    echoerr "Please specify full path at S3 (for example: /a/b/c)"
    exit 1
fi
if [ "$3" != "" ]; then
    aws_cli_installation_required="$3"
else
    aws_cli_installation_required=0
fi

echok "======== Start Upload To S3 ========"
echo "File to Upload: ${file_to_upload}"
echo "full path at S3: ${s3_path}"

# check if file exists
if [ ! -f "$file_to_upload" ]; then
    echoerr "the file: $file_to_upload doesnt exist."
    exit 1
fi

# Install AWS cli
if [ "$aws_cli_installation_required" == "1" ]; then
    DEPLOY_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    cd $DEPLOY_SCRIPT_DIR
    ./install_aws_cli.sh
    if [ $? -ne 0 ]; then
        echoerr "Failed to install AWS cli"
        exit 1
    fi
    cd -
fi

# configure aws cli
file_name=${file_to_upload##*/}
aws configure set aws_access_key_id  $AWS_ACCESS_KEY # default_access_key
aws configure set aws_secret_access_key $AWS_SECRET # default_secret_key
aws configure set default.region $REGION # region

aws s3 cp $file_to_upload s3://$BUCKET/$s3_path/$file_name

if [ "$?" -ne 0 ]; then
    echoerr "Failed to upload file $file_to_upload to S3"
    exit 1
fi

echok "File $file_to_upload Uploaded to S3 in path: S3://$BUCKET/$s3_path/$file_name"
exit 0
