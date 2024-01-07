## Terraform Directory Details
This Terraform directory is designed to create AWS resources. The project includes Terraform configuration files, each serving a specific purpose.

### File Descriptions

- tf-modules: A directory containing reusable Terraform module.

- parameters-aws.tfvars: Variable definitions file with values specific for AWS deployments.

- parameters-localstack.tfvars: Variable definitions file with values specific for LocalStack deployments.

- dynamodb-table.tf: Terraform configuration for setting up a DynamoDB table.

- lambda-code: Directory containing the source code for AWS Lambda functions.

- lambda.tf: Terraform configuration for AWS Lambda functions.

- lambda_function_payload.zip: A ZIP archive containing the packaged code for a Lambda function.(this file will be created post terraform apply)

- locals.tf: Contains local values that can be used across multiple Terraform files for reusable expressions.

- provider.tf: Configuration file defining the Terraform provider(s).

- s3.tf: Terraform configuration for AWS S3 buckets.

- step-function.tf: Terraform configuration for AWS Step Functions.

- variables.tf: Definitions of variables used across the Terraform configurations.

## Solution Considerations
This solution implements few key components described below:
- Terraform module to create iam resources for code re-use
- Tags to manage created resources easily
- Localstack AWS endpoint conditions to support deployments to both platforms
- Force deletion on s3 buckets to easily redeploy resources.(this is only for dev purposes and should not be used for production usage)
- s3 bucket logging and other security implementation is not done as it is not in the assignment scope

