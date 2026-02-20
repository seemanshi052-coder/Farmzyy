from fastapi import APIRouter, Query

from app.services.market_service import market_service


router = APIRouter(prefix="/market", tags=["Market"])


@router.get("/price")
def get_market_price(
    crop: str = Query(...),
    state: str = Query(None)
):

    try:

        result = market_service.get_market_price(
            crop=crop,
            state=state
        )

        return {
            "success": True,
            "data": result
        }

    except Exception as e:

        return {
            "success": False,
            "error": {
                "code": 500,
                "message": str(e)
            }
        }
