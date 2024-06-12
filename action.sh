#!/bin/bash
export HELM_EXPERIMENTAL_OCI=1
set -e

if [[ "${INPUT_ECR_LOGIN}" == "true" ]]; then
    aws ecr get-login-password --region ${INPUT_AWS_REGION} | helm registry login --username AWS --password-stdin "${INPUT_AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com"
    echo "✅ AWS ECR Login Complete"
fi

HELM_VERSION="$(helm version --template='Version: {{.Version}}' )"
HELM_VERSION=$(echo $HELM_VERSION | sed 's/[^0-9]*//g')

if [ $HELM_VERSION -ge 380 ]
then
    if [[ ${INPUT_CHART_AND_TAG} == *"monochart:latest"* ]]; then
        helm pull "oci://${INPUT_AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/monochart" --untar --untardir "${INPUT_TARGET_DIRECTORY}"
        echo "✅ Latest Monochart pulled successfully"
    else
        helm pull "oci://${INPUT_CHART_AND_TAG}" --untar --untardir "${INPUT_TARGET_DIRECTORY}"
        echo "✅ ${INPUT_CHART_AND_TAG} pulled successfully"
    fi
    echo "✅ ${INPUT_CHART_AND_TAG} saved to ${INPUT_TARGET_DIRECTORY} successfully"
    echo "::set-output name=chart-path::${INPUT_TARGET_DIRECTORY}"
else
    helm chart pull "${INPUT_CHART_AND_TAG}" 
    echo "✅ ${INPUT_CHART_AND_TAG} pulled successfully"
    helm chart export "${INPUT_CHART_AND_TAG}" --destination "${INPUT_TARGET_DIRECTORY}"
    echo "✅ ${INPUT_CHART_AND_TAG} saved to ${INPUT_TARGET_DIRECTORY} successfully"
    echo "::set-output name=chart-path::${INPUT_TARGET_DIRECTORY}"
fi
