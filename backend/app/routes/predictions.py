from fastapi import APIRouter, Depends, HTTPException

from app.schemas.prediction import (
    CropPredictionRequest,
    PestPredictionRequest,
    YieldPredictionRequest
)

from app.services.ml_service import ml_service
from app.services.prediction_service import prediction_service
from app.core.security import verify_token


router = APIRouter(prefix="/predictions", tags=["Predictions"])


# =========================================================
# CROP
# =========================================================

@router.post("/crop")
def predict_crop(
    request: CropPredictionRequest,
    user_id: str = Depends(verify_token)
):

    try:

        result = ml_service.predict_crop(request.dict())

        prediction_service.save_prediction(
            user_id=user_id,
            prediction_type="crop",
            input_data=request.dict(),
            prediction=result["prediction"],
            confidence_score=result["confidence_score"]
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


# =========================================================
# PEST
# =========================================================

@router.post("/pest")
def predict_pest(
    request: PestPredictionRequest,
    user_id: str = Depends(verify_token)
):

    try:

        result = ml_service.predict_pest(request.dict())

        prediction_service.save_prediction(
            user_id=user_id,
            prediction_type="pest",
            input_data=request.dict(),
            prediction=result["prediction"],
            confidence_score=result["confidence_score"]
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


# =========================================================
# YIELD
# =========================================================

@router.post("/yield")
def predict_yield(
    request: YieldPredictionRequest,
    user_id: str = Depends(verify_token)
):

    try:

        result = ml_service.predict_yield(request.dict())

        prediction_service.save_prediction(
            user_id=user_id,
            prediction_type="yield",
            input_data=request.dict(),
            prediction=result["prediction"],
            confidence_score=result["confidence_score"]
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
