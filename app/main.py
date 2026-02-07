from fastapi import FastAPI
from app.database import get_connection, insert_optin_message
from app.schemas import OptinMessageCreate

app = FastAPI()

@app.get("/health/db")
def check_db():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT 1")
    result = cursor.fetchone()
    conn.close()

    return {"database": "connected", "result": result[0]}


@app.post("/optin")
def create_optin(data: OptinMessageCreate):
    insert_optin_message(
        phone_number=data.phone_number,
        message_text=data.message_text
    )

    return {"status": "success", "message": "Opt-in registrado com sucesso"}
