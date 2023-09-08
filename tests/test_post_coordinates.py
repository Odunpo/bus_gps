import os

import pytest

from src.lambda_kinesis_consumer.index import post_coordinates
from .helpers import dict_to_base64_str, two_lists_are_equal

TABLE_NAME = os.environ["DYNAMODB_TABLE_NAME"]

DEFAULT_GPS = {
    "longitude": "12.34567",
    "latitude": "76.54321"
}
DEFAULT_GPS_ITEM = {
    "longitude": {"S": DEFAULT_GPS["longitude"]},
    "latitude": {"S": DEFAULT_GPS["latitude"]},
}


@pytest.mark.parametrize(
    "event_to_process,expected_scanned_items",
    [
        (
            {
                "Records":
                    [
                        {
                            "kinesis": {
                                "partitionKey": "21",
                                "data": dict_to_base64_str(DEFAULT_GPS),
                                "approximateArrivalTimestamp": 1693481696
                            },
                        },
                        {
                            "kinesis": {
                                "partitionKey": "21",
                                "data": dict_to_base64_str(DEFAULT_GPS),
                                "approximateArrivalTimestamp": 1693481697
                            },
                        },
                        {
                            "kinesis": {
                                "partitionKey": "30",
                                "data": dict_to_base64_str(DEFAULT_GPS),
                                "approximateArrivalTimestamp": 1693481702
                            },
                        }
                    ]
            },
            [
                {
                    "busId": {"S": "21"},
                    "expirationTime": {"N": "1693485297"},
                    "updatedAt": {"N": "1693481697"},
                    **DEFAULT_GPS_ITEM,
                },
                {
                    "busId": {"S": "30"},
                    "expirationTime": {"N": "1693485302"},
                    "updatedAt": {"N": "1693481702"},
                    **DEFAULT_GPS_ITEM,
                }
            ]
        ),
        (
                {
                    "Records":
                        [
                            {
                                "kinesis": {
                                    "partitionKey": str(i),
                                    "data": dict_to_base64_str(DEFAULT_GPS),
                                    "approximateArrivalTimestamp": 1693481697
                                },
                            }
                            for i in range(30)
                        ]
                },
                [
                    {
                        "busId": {"S": str(i)},
                        "expirationTime": {"N": "1693485297"},
                        "updatedAt": {"N": "1693481697"},
                        **DEFAULT_GPS_ITEM,
                    }
                    for i in range(30)
                ]
        ),
    ]
)
def test_post_coordinates(
    dynamodb_local,
    event_to_process,
    expected_scanned_items,
):
    dynamodb_client, _ = dynamodb_local
    post_coordinates(event_to_process, dynamodb_client)

    received_scan_result = dynamodb_client.scan(TableName=TABLE_NAME)
    received_scan_items = received_scan_result["Items"]
    assert two_lists_are_equal(received_scan_items, expected_scanned_items)
