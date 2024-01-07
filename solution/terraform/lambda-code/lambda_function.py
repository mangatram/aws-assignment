import json
import boto3
import uuid
import os
import logging

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    try:
        # Retrieve environment variables
        region = os.environ.get("REGION")
        state_machine_arn = os.environ.get("STATE_MACHINE_ARN")
        endpoint_url = os.environ.get("ENDPOINT_URL")

        # Validate environment variables
        if not region:
            logger.error("Missing 'REGION' environment variable.")
            raise ValueError("Missing 'REGION' environment variable.")
        if not state_machine_arn:
            logger.error("Missing 'STATE_MACHINE_ARN' environment variable.")
            raise ValueError("Missing 'STATE_MACHINE_ARN' environment variable.")
        
        def create_sf_client(region):
            # Configure Step Functions client for LocalStack or AWS
            if 'LOCALSTACK_HOSTNAME' in os.environ:
                if not endpoint_url:
                    logger.error("Missing 'ENDPOINT_URL' environment variable.")
                    raise ValueError("Missing 'ENDPOINT_URL' environment variable.")
                return boto3.client('stepfunctions', region_name=region, endpoint_url=endpoint_url)
            return boto3.client('stepfunctions', region_name=region)
        
        # Logging variables
        logger.info(f'Region: {region}')
        logger.info(f'State Machine ARN: {state_machine_arn}')
        logger.info(f'Endpoint URL: {endpoint_url}')

        # Extract bucket name and file name from S3 event
        bucket = event['Records'][0]['s3']['bucket']['name']
        fileName = event['Records'][0]['s3']['object']['key']

        # Initialize Step Functions client
        sf = create_sf_client(region)

        # Prepare input for Step Function
        input_dict = {'fileName': fileName}
        
        # Generate a unique execution name
        execution_name = f'execution_{bucket}_{fileName}_{uuid.uuid4().hex}'
        
        # Initiate Step Function execution
        response = sf.start_execution(
            stateMachineArn=state_machine_arn,
            name=execution_name,
            input=json.dumps(input_dict)
        )
        
        logger.info(f'Started execution: {execution_name}')
        
        return {
            'statusCode': 200,
            'body': json.dumps('Step Function execution started successfully.')
        }
    except Exception as e:
        logger.error(f'Error: {str(e)}')
        return {
            'statusCode': 500,
            'body': json.dumps(f'Error: {str(e)}')
        }
