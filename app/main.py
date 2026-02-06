from fastapi import FastAPI

app = FastAPI()

app = FastAPI(title="Opt-in Message Manager API")

@app.get("/")
def read_root():
    return {"status": "API is running"}
