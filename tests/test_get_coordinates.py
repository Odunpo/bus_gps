import json

import pytest

from src.get_coordinates_function.index import get_coordinates

ITEM_TO_PUT = {
    "busId": "testBusId",
    "longitude": "12.34567",
    "latitude": "76.54321",
    "updatedAt": "1234567890"
}


@pytest.mark.parametrize(
    "event_to_process,expected_code,expected_item",
    [
        (
            {"busId": "testBusId"},
            200,
            ITEM_TO_PUT,
        ),
        (
            {"busId": "wrongBusId"},
            200,
            {},
        ),
        (
            {"busId": ""
                      ""},
            400,
            {"error": "Param busId is required"},
        ),
    ]
)
def test_get_coordinates(
        dynamodb_local,
        event_to_process,
        expected_code,
        expected_item,
):
    _, dynamodb_table = dynamodb_local
    dynamodb_table.put_item(Item=ITEM_TO_PUT)

    response = get_coordinates(event_to_process, dynamodb_table)
    received_item = json.loads(response["body"])

    assert response["statusCode"] == expected_code
    assert received_item == expected_item
