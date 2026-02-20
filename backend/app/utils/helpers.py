def success_response(data=None, message: str = ""):
    return {
        "success": True,
        "data": data or {},
        "message": message
    }


def error_response(code: int, message: str):
    return {
        "success": False,
        "error": {
            "code": code,
            "message": message
        }
    }
