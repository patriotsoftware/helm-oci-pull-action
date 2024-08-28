#!/bin/bash
export HELM_EXPERIMENTAL_OCI=1
set -e

if [[ "${INPUT_ECR_LOGIN}" == "true" ]]; then
    aws ecr get-login-password --region ${INPUT_AWS_REGION} | helm registry login --username AWS --password-stdin "${INPUT_AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com"
    echo "✅ AWS ECR Login Complete"
fi

HELM_VERSION="$(helm version --template='Version: {{.Version}}' )"
HELM_VERSION=$(echo $HELM_VERSION | sed 's/[^0-9]*//g')

if [[ "$INPUT_VERSION" == "" ]]; then
    VERSION=""
else
    VERSION="--version $INPUT_VERSION"
fi

if [ $HELM_VERSION -ge 380 ]
then
    if [[ ${INPUT_CHART} == *"monochart:latest"* ]]; then
        helm pull "oci://${INPUT_AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/monochart" --untar --untardir "${INPUT_TARGET_DIRECTORY}" $VERSION
        echo "✅ Latest Monochart pulled successfully"
    else
        helm pull "oci://${INPUT_CHART}" --untar --untardir "${INPUT_TARGET_DIRECTORY}" $VERSION
        echo "✅ ${INPUT_CHART} pulled successfully"
    fi
    echo "✅ ${INPUT_CHART} saved to ${INPUT_TARGET_DIRECTORY} successfully"
    echo "::set-output name=chart-path::${INPUT_TARGET_DIRECTORY}"
else
    helm chart pull "${INPUT_CHART}" 
    echo "✅ ${INPUT_CHART} pulled successfully"
    helm chart export "${INPUT_CHART}" --destination "${INPUT_TARGET_DIRECTORY}"
    echo "✅ ${INPUT_CHART} saved to ${INPUT_TARGET_DIRECTORY} successfully"
    echo "::set-output name=chart-path::${INPUT_TARGET_DIRECTORY}"
fi
