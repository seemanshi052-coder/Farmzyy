import time
from fastapi import Request, HTTPException


class RateLimiter:

    def __init__(self, limit: int = 10, window: int = 60):
        """
        limit = number of requests
        window = seconds
        """
        self.limit = limit
        self.window = window
        self.requests = {}

    def __call__(self, request: Request):

        client_ip = request.client.host
        current_time = time.time()

        if client_ip not in self.requests:
            self.requests[client_ip] = []

        # Remove old requests
        self.requests[client_ip] = [
            t for t in self.requests[client_ip]
            if current_time - t < self.window
        ]

        if len(self.requests[client_ip]) >= self.limit:
            raise HTTPException(
                status_code=429,
                detail="Too many requests"
            )

        self.requests[client_ip].append(current_time)


chat_rate_limiter = RateLimiter(limit=15, window=60)
