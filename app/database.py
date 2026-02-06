import pyodbc
import os

def get_connection():
    server = os.getenv("DB_HOST", "optin_sqlserver")
    database = os.getenv("DB_NAME", "master")
    username = os.getenv("DB_USER", "sa")
    password = os.getenv("DB_PASSWORD", "YourStrong!Passw0rd")

    connection_string = (
        "DRIVER={ODBC Driver 18 for SQL Server};"
        f"SERVER={server};"
        f"DATABASE={database};"
        f"UID={username};"
        f"PWD={password};"
        "TrustServerCertificate=yes;"
    )

    return pyodbc.connect(connection_string)
