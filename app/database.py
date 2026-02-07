import pyodbc
from app.config import settings


def get_connection():
    connection_string = (
        f"DRIVER={{{settings.DB_DRIVER}}};"
        f"SERVER={settings.DB_HOST};"
        f"DATABASE={settings.DB_NAME};"
        f"UID={settings.DB_USER};"
        f"PWD={settings.DB_PASSWORD};"
        "TrustServerCertificate=yes;"
    )

    return pyodbc.connect(connection_string)


def insert_optin_message(phone_number: str, message_text: str):
    conn = get_connection()
    cursor = conn.cursor()

    query = """
        INSERT INTO optin_messages (phone_number, message_text)
        VALUES (?, ?)
    """

    cursor.execute(query, (phone_number, message_text))
    conn.commit()

    cursor.close()
    conn.close()
