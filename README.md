# Solution Documentation
Make sure to clone the repo before execution terraform and cloudformation solution instructions.
#### Clone the repo
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


## How to Use

### Navigate to terraform solution directory
```shell
cd solution/tf
```

### Starting LocalStack

Run the following command to start localstack:

```shell
docker-compose up  
```
Watch the logs for `Execution of "preload_services" took 986.95ms` 

### Authentication
```shell
export AWS_ACCESS_KEY_ID=foobar
export AWS_SECRET_ACCESS_KEY=foobar
export AWS_REGION=eu-central-1
```

## terraform execution

Make sure terraform is installed on the machine executing these commands. Follow the instructions here: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

## Terraform init, plan and apply
```shell
terraform init
terraform plan --var-file="parameters-localstack.tfvars"
# run below after validating terraform plan output
terraform apply --var-file="parameters-localstack.tfvars" --auto-approve
```
## Validate functionality
##### upload a file to s3 bucket
```shell
aws --endpoint-url http://localhost:4566 s3 cp README.md s3://test-bucket/
```
##### verify step function trigger

```shell
# if below output shows an entry for above copied file name, the execution is a success
aws --endpoint-url http://localhost:4566 dynamodb scan --table-name Files
```
</details>

<details>
<summary><b>Cloudformation</b></summary>