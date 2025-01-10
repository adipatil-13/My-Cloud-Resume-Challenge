import json
import boto3 # type: ignore
import logging

# Initialize DynamoDB client
dynamodb = boto3.resource('dynamodb')

# Configure logging
logging.basicConfig(level=logging.INFO)

def lambda_handler(event, context):
    logging.info('AWS Lambda function processed a request.')
    
    try:
        # Extract table name from the event body
        body = json.loads(event['body'])
        table_name = body.get('tableName')
        table = dynamodb.Table(table_name)
        partition_key = "key"
        partition_key_value = "visitor_count"
        counter_attribute = "counter"

        # Retrieve the entity from the table
        response = table.get_item(Key={partition_key: partition_key_value})
        item = response.get('Item')

        if item:
            # Decrement the counter by 1
            counter = item[counter_attribute] - 1
            item[counter_attribute] = counter

            # Update the entity in DynamoDB
            table.put_item(Item=item)

            # Return the counter as a plain text response
            return {
                'statusCode': 200,
                'body': str(counter)
            }
        else:
            return {
                'statusCode': 404,
                'body': "Visitor count not found."
            }
    except Exception as e:
        logging.error(f"Error retrieving or updating entity: {e}")
        return {
            'statusCode': 500,
            'body': f"Error retrieving or updating visitor count: {str(e)}"
        }