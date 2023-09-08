import base64
import json


def dict_to_base64_str(data: dict) -> str:
    jdata = json.dumps(data)
    bdata = jdata.encode("utf-8")
    b64data = base64.b64encode(bdata)
    sb64data = b64data.decode("utf-8")

    return sb64data


def two_lists_are_equal(scan_result1: list, scan_result2: list) -> bool:
    if len(scan_result1) != len(scan_result2):
        return False

    for item in scan_result1:
        if item not in scan_result2:
            return False

    return True
