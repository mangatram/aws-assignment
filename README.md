# Solution Documentation
This repository contains solution files with documentation to deploy AWS localstack resources with terraform and cloudformation template. 

Each solution directory contains a README.md which contains details around different components used.

Follow below instructions to deploy the solution.
### Clone the repo
```shell
git clone https://github.com/mangatram/aws-assignment.git
```
<details>
<summary><b>Terraform</b></summary>


Terraform creates the following resources:
- An S3 Bucket for file uploads name test-bucket (this can be changed in parameter file named parameters.tfvars).
- A DynamoDb table named `Files` with an attribute `FileName`.
- A Step Function to log uploaded files in the DynamoDb table.
- A Lambda function triggered by file uploads, executing the Step Function.

Note: 
- Above parameters can be changed as required in parameters.tfvars file
- Endpoint URL for localstack is parameterized to allow the code to run on aws


### How to Use

#### Navigate to terraform solution directory
```shell
cd solution/terraform
```

#### Starting LocalStack

Run the following command to start localstack:

```shell
docker-compose up  
```
Watch the logs for `Execution of "preload_services" took 986.95ms` 

#### Authentication
```shell
export AWS_ACCESS_KEY_ID=foobar
export AWS_SECRET_ACCESS_KEY=foobar
export AWS_REGION=eu-central-1
```

#### Terraform execution

Make sure terraform is installed on the machine executing these commands. Follow the install instructions [here](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

#### Terraform init, plan and apply
```shell
terraform init
terraform plan --var-file="parameters-localstack.tfvars"
terraform apply --var-file="parameters-localstack.tfvars" --auto-approve # run this after validating terraform plan output
```
#### Validate functionality
###### upload a file to s3 bucket
```shell
aws --endpoint-url http://localhost:4566 s3 cp README.md s3://test-bucket/ --region "eu-central-1" # remove region parameter if it givens a parameter error
```
##### verify step function trigger

```shell
aws --endpoint-url http://localhost:4566 dynamodb scan --table-name Files --region "eu-central-1" # remove region parameter if it givens a parameter error
```
</details>

<details>
<summary><b>Cloudformation</b></summary>

Cloudformation template stack creates the following resources:
- Two S3 buckets
    - One for primary assignment requirements
    - One dedicated to storing access logs (to address cfn-nag warnings)

Note: The template assigns root iam as the s3 access principal as it is not specified in the assignment instructions to which application(s) this s3 bucket will be assigned or used for. Below are the key improvements that can be further implemented:
- Key Improvement: Replace root IAM as the S3 access principal with more granular permissions.
- Recommendation: Grant access directly to the specific application or roles requiring it, aligning with least privilege principles.

### How to Use

#### Navigate to terraform solution directory
```shell
cd solution/cloudformation
```

#### Starting LocalStack

Run the following command to start localstack:

```shell
docker-compose up  
```
Watch the logs for `Execution of "preload_services" took 986.95ms` 

#### Authentication
```shell
export AWS_ACCESS_KEY_ID=foobar
export AWS_SECRET_ACCESS_KEY=foobar
export AWS_REGION=eu-central-1
```

#### Stack execution
A parameter file is used (parameters.json) to avoid supplying parameters on the command line.
```shell
aws --endpoint-url http://localhost:4566 cloudformation create-stack --template-body file://stack.template --parameters file://parameters.json --stack-name "stack-01" --region "eu-central-1" # remove region parameter if it givens a parameter error, input stack-name parameter as required
```

## CFN-NAG Report
### Show last report
```shell
docker logs cfn-nag
```

### Recreate report
```shell
docker-compose restart cfn-nag
```

</details>
