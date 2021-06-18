#!/bin/bash
export HELM_EXPERIMENTAL_OCI=1
set -e
if [[ "${INPUT_ECR_LOGIN}" == "true" ]]; then
    aws ecr get-login-password --region ${INPUT_AWS_REGION} | helm registry login --username AWS --password-stdin "${INPUT_AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com"
    echo "✅ AWS ECR Login Complete"
fi
helm chart pull "${INPUT_CHART_AND_TAG}" 
echo "✅ ${INPUT_CHART_AND_TAG} pulled successfully"
helm chart export "${INPUT_CHART_AND_TAG}" --destination "${INPUT_TARGET_DIRECTORY}"
echo "✅ ${INPUT_CHART_AND_TAG} saved to ${INPUT_TARGET_DIRECTORY} successfully"
echo "::set-output name=chart-path::${INPUT_TARGET_DIRECTORY}"