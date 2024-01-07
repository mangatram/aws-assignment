<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.46.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.lambda_function_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_role-Service"></a> [role-Service](#input\_role-Service) | service url this role applies to. example: lambda.amazonaws.com | `string` | n/a | yes |
| <a name="input_role-prefix"></a> [role-prefix](#input\_role-prefix) | Role prefix : ideally the name of the resource to which this resource belongs. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to be applied to the resource | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | arn for the created iam resource |
| <a name="output_name"></a> [name](#output\_name) | name of the created iam resource |
<!-- END_TF_DOCS -->