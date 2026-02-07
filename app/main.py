from fastapi import FastAPI
from app.database import insert_optin_message
from app.schemas import OptinMessageCreate
from app.database import get_optin_messages

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

@app.get("/optin")
def list_optins():
    return get_optin_messages()

