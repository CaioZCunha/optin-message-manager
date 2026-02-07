from pydantic import BaseModel, Field, validator
import re


class OptinMessageCreate(BaseModel):
    phone_number: str = Field(..., example="+5511999999999")
    message_text: str = Field(..., max_length=500)

    @validator("phone_number")
    def validate_phone_number(cls, value):
        pattern = r"^\+\d{10,15}$"
        if not re.match(pattern, value):
            raise ValueError("Telefone deve estar no formato internacional. Ex: +5511999999999")
        return value
