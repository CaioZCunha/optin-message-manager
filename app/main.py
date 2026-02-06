from fastapi import FastAPI
from app.database import get_connection

app = FastAPI()

@app.get("/health/db")
def check_db():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT 1")
    result = cursor.fetchone()
    conn.close()

    return {"database": "connected", "result": result[0]}
