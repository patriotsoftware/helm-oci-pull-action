# helm-pull-action
A GitHub Action for pulling a Helm chart from an OCI-compliant repository. We recommend using `patriotsoftware/helm-pull-action@v1` to get the latest changes.

## Example Usage
```
      - name: Pull Helm Chart
        id: helm-pull
        uses: ./
        with:
          chart-and-tag: public.ecr.aws/tibcolabs/labs-air-helm-charts:air
```

### Available Inputs
```
inputs:
  chart-and-tag: 
    description: Helm Chart and tag to pull
    required: true
  target-directory:
    description: Target base directory to use when saving the chart locally. Will save to <target-directory>/<chart-name>
    required: false
    default: "./"
  ecr-login:
    description: "Values: true/false. Require ECR Login to pull"
    required: false
    default: "false"
  aws-account-id:
    description: Account ID used for ECR login
    required: false
  aws-region:
    description: Region used for ECR login
    required: false
    default: us-east-1
```

### Available Outputs
```
outputs:
  chart-path: 
    description: Path to the locally pulled chart
    value: ${{ steps.pull-chart.outputs.chart-path }}
```