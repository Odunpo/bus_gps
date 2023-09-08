import json
import os

import boto3
from botocore.exceptions import ClientError


def lambda_handler(event, context):
    table = get_dynamodb_table()
    return get_coordinates(event, table)


def get_coordinates(event, table):
    bus_id = event["busId"]
    if not bus_id:
        body = json.dumps({"error": "Param busId is required"})

        return {"statusCode": 400, "body": body}

    try:
        projection_expression = "#b, latitude, longitude, updatedAt"
        expression_attribute_names = {"#b": "busId"}
        data = table.get_item(
            Key={"busId": bus_id},
            ProjectionExpression=projection_expression,
            ExpressionAttributeNames=expression_attribute_names
        )
    except ClientError as error:
        body = json.dumps({"error": error.response["Error"]["Message"]})

        return {"statusCode": 400, "body": body}

    except BaseException as error:
        raise error

    item = data.get("Item")
    if item is not None:
        item["updatedAt"] = str(item["updatedAt"])
        body = json.dumps(item)
    else:
        body = "{}"

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": body,
    }


def get_dynamodb_table():
    region = boto3.session.Session().region_name
    dynamodb = boto3.resource("dynamodb", region_name=region)
    return dynamodb.Table(os.environ["DYNAMODB_TABLE_NAME"])
