## Cloudformation
This directory is designed to create AWS resources using cloudformation template. The project includes cloudformation template, parameter file, each serving a specific purpose.

## File Descriptions

- stack.template: cloudformation template definining resources.

- parameters.json: Parameter file to store dynamic values for resource creation.

## Solution Considerations
This solution implements few key components described below:
- Encryption enablement on s3 resources
- Tags to manage created resources easily
- Logging on s3 bucket

## cfn-nag warning suppression for recursive logging
The logging bucket has an exception added for cfn-nag to suppress logging warning as that creates a recursive logging error. This is due to the bucket is supposed store logs.
Reference : [s3-server-access-logging-trustedadvisor-warning](https://repost.aws/questions/QUCxFo7NdaQhCSCbQwb20i4Q/avoid-recursive-s3-server-access-logging-trustedadvisor-warning)

## root iam for s3 access
The template assigns root iam as the s3 access principal as it is not specified in the assignment instructions to which application(s) this s3 bucket will be assigned or used for.

The solution is to use an IAM role which should be created outside of cloudformation template. Since this is not in the scope of the assesment, it has not been implemented.

Note: Above assumptions are based on my initial understanding of AWS. Glad to implement any best practices or feedback.