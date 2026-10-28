#!/bin/bash

set -e

ENVIRONMENT=$1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
LOG_DIR="$PROJECT_DIR/logs"
LOG_FILE="$LOG_DIR/logs.log"

mkdir -p "$LOG_DIR"

if [[ -z "$ENVIRONMENT" ]]; then
    echo "Error: No environment specified. Please provide an environment (e.g., dev, staging, prod)." | tee -a "$LOG_FILE"
    echo "Usage: ./deploy.sh <environment>"
    exit 1
fi

if [[ "$ENVIRONMENT" != "dev" && 
        "$ENVIRONMENT" != "test" && 
        "$ENVIRONMENT" != "prod" ]]; then
    echo "Error: The specified environment '$ENVIRONMENT' does not exist." | tee -a "$LOG_FILE"
    exit 1
fi

echo "============================================="
echo " Terraform S3 Website Deployment $ENVIRONMENT"
echo "============================================="

checkdependencies(){
    echo 
    echo "INFO: Checking Terraform..." | tee -a "$LOG_FILE"

    if command -v terraform >/dev/null 2>&1; then
        echo "OK: Terraform: OK" | tee -a "$LOG_FILE"
    else
        echo "Error: Terraform is not installed" | tee -a "$LOG_FILE"
        exit 1
    fi

    echo
    echo "INFO: Checking AWS CLI..." | tee -a "$LOG_FILE"

    if command -v aws >/dev/null 2>&1; then
        echo "OK: AWS CLI: OK" | tee -a "$LOG_FILE"
    else
        echo "Error: AWS CLI is not installed" | tee -a "$LOG_FILE"
        exit 1
    fi
}

terraforminit(){
    echo
    echo "INFO: Initializing Terraform..." | tee -a "$LOG_FILE"

    terraform -chdir=../terraform/$ENVIRONMENT init
}

terraformvalidate(){
    echo
    echo "INFO: Validating Terraform..." | tee -a "$LOG_FILE"

    terraform -chdir=../terraform/$ENVIRONMENT validate
}

terraformplan(){
    echo
    echo "INFO: Creating Terraform plan..." | tee -a "$LOG_FILE"

    terraform -chdir=../terraform/$ENVIRONMENT plan
}

terraformapply(){
    echo
    echo "INFO: Applying Terraform..." | tee -a "$LOG_FILE"

    terraform -chdir=../terraform/$ENVIRONMENT apply \
        --auto-approve
}

deploy_website(){
    echo
    echo "INFO: Deploying website..." | tee -a "$LOG_FILE"
    aws s3 sync ../website/ s3://$BUCKET_NAME --delete
    echo "INFO: Website deployed successfully!" | tee -a "$LOG_FILE"
}


main(){
    
    echo "=================================" | tee -a "$LOG_FILE"
    echo " Terraform S3 Website Deployment" | tee -a "$LOG_FILE"
    echo " Environment: $ENVIRONMENT" | tee -a "$LOG_FILE"
    echo "=================================" | tee -a "$LOG_FILE"
    checkdependencies
    terraforminit
    terraformvalidate
    terraformplan
    terraformapply
    BUCKET_NAME=$(terraform -chdir=../terraform/$ENVIRONMENT output -raw bucket_name)
    BUCKET_ARN=$(terraform -chdir=../terraform/$ENVIRONMENT output -raw bucket_arn)
    echo
    deploy_website
    echo "INFO: Deployment complete!" | tee -a "$LOG_FILE"
    echo
    echo "INFO: ENVIRONMENT: $ENVIRONMENT" | tee -a "$LOG_FILE"
    echo "INFO: Bucket Name: $BUCKET_NAME" | tee -a "$LOG_FILE"
    echo "INFO: Bucket ARN: $BUCKET_ARN" | tee -a "$LOG_FILE"

}   

main "$@"