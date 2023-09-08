import base64
import json
import os
import re

import boto3

DYNAMODB_TABLE = os.environ["DYNAMODB_TABLE_NAME"]
TTL_SECONDS = int(os.environ["TTL_SECONDS"])
TTL_FIELD_NAME = os.environ["TTL_FIELD_NAME"]


def lambda_handler(event, context):
    print(event)
    dynamodb_client = get_dynamodb_client()
    return post_coordinates(event, dynamodb_client)


def get_dynamodb_client():
    region = boto3.session.Session().region_name

    return boto3.client("dynamodb", region_name=region)


def post_coordinates(event, client) -> dict:
    records = event["Records"]

    items = records_to_items(records)
    item_put_requests = items_to_item_put_requests(items)
    splitted_item_put_requests = split_items_by_25(item_put_requests)

    for batch in splitted_item_put_requests:
        client.batch_write_item(RequestItems={DYNAMODB_TABLE: batch})

    return {"statusCode": 200}


def records_to_items(records: list) -> dict:
    items = {}

    for record in records:
        partition_key = record["kinesis"].get("partitionKey")
        raw_data = record["kinesis"]["data"]
        data = base64_to_dict(raw_data)

        lon, lat = data.get("longitude"), data.get("latitude")
        if not is_valid_gps_coordinates(lon, lat) or partition_key is None:
            # TODO: send bad records to SQS dead queue
            continue

        arrival_ts = int(record["kinesis"]["approximateArrivalTimestamp"])
        data["updatedAt"] = arrival_ts

        expiration_ts = arrival_ts + TTL_SECONDS
        data[TTL_FIELD_NAME] = expiration_ts

        items[partition_key] = data

    return items


def items_to_item_put_requests(items: dict) -> list:
    item_put_requests = []

    for key, item in items.items():
        put_request = {
            "PutRequest": {
                "Item": {
                    "busId": {"S": key},
                    "longitude": {"S": item["longitude"]},
                    "latitude": {"S": item["latitude"]},
                    "updatedAt": {"N": str(item["updatedAt"])},
                    TTL_FIELD_NAME: {"N": str(item[TTL_FIELD_NAME])},
                }
            }
        }

        item_put_requests.append(put_request)

    return item_put_requests


def base64_to_dict(data: str) -> dict:
    b64_decoded_data = base64.b64decode(data.encode("utf-8"))
    json_data = b64_decoded_data.decode("utf-8")

    return json.loads(json_data)


def split_items_by_25(items: list) -> list:
    chunk_size = 25

    return [items[i:i + chunk_size] for i in range(0, len(items), chunk_size)]


def is_valid_gps_coordinates(lon, lat):
    pattern = r"^[-]?(?:\d{1,2})\.\d{5}$"

    is_lon_valid = re.match(pattern, lon) is not None
    is_lat_valid = re.match(pattern, lat) is not None

    return is_lon_valid and is_lat_valid
