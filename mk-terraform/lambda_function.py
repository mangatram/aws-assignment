import json
import boto3
import uuid
import os

def lambda_handler(event, context):
    try:
        # fetch environment variables
        region = os.environ.get("REGION")
        state_machine_arn = os.environ.get("STATE_MACHINE_ARN")

        # check if environment variables are missing
        if region is None:
            raise ValueError("missing region environment variable ")
        if state_machine_arn is None:
            raise ValueError("missing state machine arn environment variable")
        
        # log the variables
        print(f'region is : {region}')
        print(f'state machine arn : {state_machine_arn}')

        # Retrieve the bucket name and file name from the S3 event
        bucket = event['Records'][0]['s3']['bucket']['name']
        fileName = event['Records'][0]['s3']['object']['key']

        # Define the Step Functions client
        sf = boto3.client('stepfunctions', region_name=region)

        # Create an input dictionary with the file name
        input_dict = {'fileName': fileName}
        
        # execution name
        execution_name = f'execution_{bucket}_{fileName}_{uuid.uuid4().hex}'
        #execution_name = 'execution3'
        
        # Start the Step Function execution
        response = sf.start_execution(
            stateMachineArn=state_machine_arn,
            name=execution_name,
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
