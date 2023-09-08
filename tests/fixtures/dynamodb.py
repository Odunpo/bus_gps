import os

import boto3
import pytest
from botocore.exceptions import ClientError


@pytest.fixture()
def dynamodb_local():
    table_name = os.environ["DYNAMODB_TABLE_NAME"]
    hostname = os.environ["DYNAMODB_HOST"]
    port = os.environ["DYNAMODB_PORT"]
    local_creds = {
        "endpoint_url": "http://{}:{}".format(hostname, port),
        "region_name": "dummy",
        "aws_access_key_id": "dummy",
        "aws_secret_access_key": "dummy",
    }

    dynamodb_client = boto3.client("dynamodb", **local_creds)

    try:
        dynamodb_client.delete_table(TableName=table_name)
    except ClientError as error:
        if error.response["Error"]["Code"] == "ResourceNotFoundException":
            pass
        else:
            raise error

    dynamodb_client.create_table(
        TableName=table_name,
        AttributeDefinitions=[
            {
                "AttributeName": "busId",
                "AttributeType": "S",
            }
        ],
        KeySchema=[
            {
                "AttributeName": "busId",
                "KeyType": "HASH",
            }
        ],
        ProvisionedThroughput={
            "ReadCapacityUnits": 1,
            "WriteCapacityUnits": 1,
        }
    )

    dynamodb_resource = boto3.resource("dynamodb", **local_creds)
    dynamodb_table = dynamodb_resource.Table(table_name)

    return dynamodb_client, dynamodb_table
