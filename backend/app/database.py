from typing import Optional


class Database:
    def __init__(self):
        self.client: Optional[object] = None

    def connect(self):
        # Initialize DB connection here
        pass

    def get_client(self):
        return self.client


db = Database()
