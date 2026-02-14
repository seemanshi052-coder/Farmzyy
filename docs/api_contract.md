# 🌾 FarmZyy API Contract (v1)

This document defines all backend API endpoints, request formats, response formats, authentication rules, and integration standards for the FarmZyy system.

Base URL:
http://<backend-domain>/api/v1

All APIs return JSON.

--------------------------------------------------------------------

🔐 AUTHENTICATION

All protected routes require:

Authorization Header:
Authorization: Bearer <access_token>

Tokens are issued via JWT after login.

--------------------------------------------------------------------

📦 STANDARD SUCCESS RESPONSE FORMAT

All successful responses must follow this structure:

{
  "success": true,
  "data": {},
  "message": "Optional message"
}

--------------------------------------------------------------------

❌ STANDARD ERROR RESPONSE FORMAT

All error responses must follow this structure:

{
  "success": false,
  "error": {
    "code": 400,
    "message": "Validation error"
  }
}

--------------------------------------------------------------------

1️⃣ AUTHENTICATION

POST /auth/login

Request:
{
  "phone": "9876543210",
  "otp": "123456"
}

Response:
{
  "success": true,
  "data": {
    "access_token": "jwt_token_here",
    "user_id": "user_001"
  }
}

--------------------------------------------------------------------

2️⃣ CHATBOT (LLM POWERED)

POST /chatbot/ask

Request:
{
  "user_id": "user_001",
  "message": "What crop should I grow this season?",
  "context": {
    "soil_type": "Loamy",
    "crop_stage": "Pre-sowing",
    "location": "West Bengal"
  }
}

Response:
{
  "success": true,
  "data": {
    "reply": "Based on your soil and rainfall, rice is recommended.",
    "confidence_score": 0.91,
    "suggested_actions": [
      "Prepare field for transplanting",
      "Use nitrogen-rich fertilizer"
    ]
  }
}

--------------------------------------------------------------------

3️⃣ CROP RECOMMENDATION

POST /crop/recommend

Request:
{
  "nitrogen": 90,
  "phosphorus": 42,
  "potassium": 43,
  "temperature": 26.5,
  "humidity": 80,
  "ph": 6.5,
  "rainfall": 200
}

Response:
{
  "success": true,
  "data": {
    "recommended_crop": "Rice",
    "confidence_score": 0.94,
    "reasoning": "High rainfall and moderate pH are suitable for rice."
  }
}

--------------------------------------------------------------------

4️⃣ YIELD PREDICTION

POST /prediction/yield

Request:
{
  "crop": "Rice",
  "land_size": 2.5,
  "fertilizer_usage": 100,
  "rainfall": 180
}

Response:
{
  "success": true,
  "data": {
    "predicted_yield": 4.2,
    "unit": "tons/hectare",
    "confidence_score": 0.88
  }
}

--------------------------------------------------------------------

5️⃣ PEST RISK ANALYSIS

POST /prediction/pest

Request:
{
  "crop": "Rice",
  "temperature": 30,
  "humidity": 85,
  "rainfall": 120
}

Response:
{
  "success": true,
  "data": {
    "risk_level": "High",
    "confidence_score": 0.86,
    "reasoning": "High humidity increases fungal infection risk."
  }
}

--------------------------------------------------------------------

6️⃣ CLIMATE RISK

POST /prediction/climate

Request:
{
  "temperature": 32,
  "rainfall_forecast": 250,
  "crop": "Rice"
}

Response:
{
  "success": true,
  "data": {
    "risk_level": "Medium",
    "recommended_action": "Delay irrigation for 3 days"
  }
}

--------------------------------------------------------------------

7️⃣ WEATHER DATA

GET /weather/current?location=WestBengal

Response:
{
  "success": true,
  "data": {
    "temperature": 28,
    "humidity": 75,
    "rain_probability": 40,
    "wind_speed": 12
  }
}

--------------------------------------------------------------------

8️⃣ MARKET TRENDS

GET /market/trends?crop=Rice

Response:
{
  "success": true,
  "data": {
    "current_price": 2200,
    "forecast_price": 2350,
    "trend": "Increasing"
  }
}

--------------------------------------------------------------------

9️⃣ HUMAN SUPPORT REQUEST

POST /human_support/request

Request:
{
  "user_id": "user_001",
  "issue": "Leaf yellowing problem"
}

Response:
{
  "success": true,
  "data": {
    "ticket_id": "ticket_101",
    "status": "Pending expert review"
  }
}

--------------------------------------------------------------------

🔄 API VERSIONING

All APIs are versioned under:

/api/v1/

Future updates must use:

/api/v2/

--------------------------------------------------------------------

🔒 SECURITY RULES

• JWT-based authentication
• Role-based access control
• Input validation using Pydantic
• Rate limiting on chatbot endpoint
• HTTPS required in production
• No API keys exposed to frontend

--------------------------------------------------------------------

📊 RESPONSE DESIGN PRINCIPLES

• Always return confidence_score for predictions
• Always include reasoning for AI decisions
• All numeric values must include unit if applicable
• Never return raw model output directly
• All responses must be JSON serializable

--------------------------------------------------------------------

This document is the single source of truth for frontend, backend, ML, and AI integration.
