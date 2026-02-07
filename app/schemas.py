from pydantic import BaseModel

class OptinMessageCreate(BaseModel):
    phone_number: str
    message_text: str
