from fastapi import FastAPI
from app.database import insert_optin_message
from app.schemas import OptinMessageCreate

app = FastAPI()


@app.post("/optin")
def create_optin(data: OptinMessageCreate):
    insert_optin_message(
        phone_number=data.phone_number,
        message_text=data.message_text
    )

    return {
        "status": "ok",
        "message": "Opt-in registrado com sucesso"
    }
