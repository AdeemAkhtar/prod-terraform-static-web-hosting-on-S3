#!/bin/bash

set -e
ENVIRONMENT=$1
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
LOG_DIR="$PROJECT_DIR/logs"
LOG_FILE="$LOG_DIR/logs.log"

mkdir -p "$LOG_DIR"


handle_error(){
    echo 
    echo "ERROR: Destroy Operation Failed!" | tee -a "$LOG_FILE"
    echo "INFO: Check the logs for more details: $LOG_FILE"
    exit 1
}

trap handle_error ERR

if [[ -z "$ENVIRONMENT" ]]; then
    echo "Error: No environment specified. Please provide an environment (e.g., dev, staging, prod)." | tee -a "$LOG_FILE"
    echo "Usage: ./destroy.sh <environment>"
    exit 1
fi

if [[ "$ENVIRONMENT" != "dev" && 
        "$ENVIRONMENT" != "test" && 
        "$ENVIRONMENT" != "prod" ]]; then
    echo "Error: The specified environment '$ENVIRONMENT' does not exist." | tee -a "$LOG_FILE"
    exit 1
fi

echo "================================="
echo " Terraform S3 Website Destruction"
echo "================================="
echo

checkdependencies(){
    echo "Checking Terraform..."

    if command -v terraform >/dev/null 2>&1; then
        echo "OK: Terraform: OK" | tee -a "$LOG_FILE"
    else
        echo "Error: Terraform is not installed" | tee -a "$LOG_FILE"
        exit 1
    fi

    if command -v aws >/dev/null 2>&1; then
        echo "OK: AWS CLI: OK" | tee -a "$LOG_FILE"
    else
        echo "Error: AWS CLI is not installed" | tee -a "$LOG_FILE"
        exit 1
    fi
}

destroyresources() {

    echo "INFO: Deleting objects from the S3 bucket" | tee -a "$LOG_FILE"

    BUCKET_NAME=$(terraform -chdir=../terraform/$ENVIRONMENT output -raw bucket_name)

    if [[ -z "$BUCKET_NAME" ]]; then
        echo "Error: Could not determine the bucket name." | tee -a "$LOG_FILE"
        exit 1
    fi

    echo "INFO: Bucket Name: $BUCKET_NAME" | tee -a "$LOG_FILE"

    echo "INFO: Deleting all objects from the S3 bucket: $BUCKET_NAME" | tee -a "$LOG_FILE"
    aws s3 rm "s3://$BUCKET_NAME" --recursive

    terraform -chdir="../terraform/$ENVIRONMENT" destroy \
        --auto-approve
}

main(){
    echo "=================================" | tee -a "$LOG_FILE"
    echo " Terraform S3 Website Destroy" | tee -a "$LOG_FILE"
    echo " Environment: $ENVIRONMENT" | tee -a "$LOG_FILE"
    echo "=================================" | tee -a "$LOG_FILE"
    checkdependencies
    destroyresources
    echo "INFO: Resources destroyed successfully" | tee -a "$LOG_FILE"
}

main "$@"