import json
import boto3
import uuid

def lambda_handler(event, context):
    try:
        # Retrieve the bucket name and file name from the S3 event
        bucket = event['Records'][0]['s3']['bucket']['name']
        fileName = event['Records'][0]['s3']['object']['key']

        # Define the Step Functions client
        sf = boto3.client('stepfunctions', region_name='eu-central-1')

        # Create an input dictionary with the file name
        input_dict = {'fileName': fileName}

        # Replace 'YourStateMachineArn' with your actual Step Function ARN
        state_machine_arn = 'arn:aws:states:eu-central-1:376447115261:stateMachine:mk-step-function-01'
        
        # execution name
        execution_name = f'execution_{uuid.uuid4().hex}'
        #execution_name = 'execution3'
        
        # Start the Step Function execution
        response = sf.start_execution(
            stateMachineArn=state_machine_arn,
            name=execution_name,  # Optionally provide a unique execution name
            input=json.dumps(input_dict)
        )
        
        print(f'Started execution: {execution_name}')
        
        return {
            'statusCode': 200,
            'body': json.dumps('Step Function execution started successfully.')
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps(f'Error: {str(e)}')
        }
