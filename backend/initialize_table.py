import json
import boto3 # type: ignore

dynamodb = boto3.resource('dynamodb')

def lambda_handler(event, context):

    # Check if the event has a body
    if 'body' in event:
        body = json.loads(event['body'])
        table_name = body.get('tableName')
        
        table = dynamodb.Table(table_name)
    
        # Check if the counter exists
        response = table.get_item(Key={'key': 'visitor_count'})
        if 'Item' not in response:
            # Initialize the counter to 0 if it does not exist
            table.put_item(Item={'key': 'visitor_count', 'counter': 0})
        else:
            # If the counter exists and is non-zero, do nothing
            counter_value = response['Item'].get('counter', 0)
            if counter_value == 0:
                table.put_item(Item={'key': 'visitor_count', 'counter': 0})
        
        return {
            'statusCode': 200,
            'body': json.dumps('Initialization complete')
        }
    
    return {
        'statusCode': 400,
        'body': json.dumps('Invalid request')
    }