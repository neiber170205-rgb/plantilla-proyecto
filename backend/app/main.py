from fastapi import FastAPI

app = FastAPI(title="Semillero SINDES")


@app.get("/api/salud")
def salud():
    return {"estado": "ok"}
