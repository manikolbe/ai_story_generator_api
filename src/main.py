import boto3
import json
from botocore.exceptions import ClientError

def lambda_handler(event, context):
    # Extract the text prompt from the API Gateway event
    body_content = json.loads(event['body'])
    prompt = body_content.get('prompt')
    print(f"Received prompt: {prompt}") 

    if not prompt:
        return {
            'statusCode': 400,
            'body': json.dumps({'error': 'Prompt is required'})
        }

    # Initialize the Bedrock client
    bedrock = boto3.client('bedrock-runtime', region_name='us-east-1')

    # Define the model ID and parameters
    model_id = 'anthropic.claude-3-5-sonnet-20240620-v1:0'
    parameters = {
        "anthropic_version": "bedrock-2023-05-31",
        "max_tokens": 512,
        "temperature": 0.5,
        "messages": [
        {
            "role": "user",
            "content": f"""You are a kids story teller.
I want you to tell me a small story based on this topic: {prompt}
You should reply back a json dictionary with 'story' as key and story text as value."""
        },
        {
            "role": "assistant",
            "content": "Here is the JSON requested:{"
        }
    ]
    }

    # Invoke the Bedrock model
    try:
        response = bedrock.invoke_model(
            body=json.dumps(parameters),
            modelId=model_id
        )
    except (ClientError, Exception) as e:
        print(f"ERROR: Can't invoke '{model_id}'. Reason: {e}")
        exit(1)
    

    # Parse the response
    response_body = response['body'].read().decode('utf-8')
    response_body_json = json.loads(response_body)
    response_text = response_body_json["content"][0]["text"]

    # Attempt to extract story JSON from response
    json_response_text = "{" + response_text
    story = json.loads(json_response_text)['story']
    print(story)

    # return {
    #     'statusCode': 200,
    #     'story': str(story),
    #     'headers': {
    #         'Content-Type': 'application/json'
    #     }
    # }
    return {
        "statusCode": 200,
        # "headers": {
        #     "Content-Type": "*/*"
        # },
        "body": story
    }
   
