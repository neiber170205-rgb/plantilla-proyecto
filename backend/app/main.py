import os
from pathlib import Path

from dotenv import load_dotenv
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

# El .env es uno solo para todo el proyecto y vive en la raiz del repo.
load_dotenv(Path(__file__).resolve().parents[2] / ".env")

app = FastAPI(title="Semillero SINDES")

# Sin esto el navegador bloquea TODAS las peticiones del frontend, porque corre
# en otro puerto (5173) que el backend (8000). El error que sale en consola es
# "blocked by CORS policy". Cuando el proyecto se despliegue, se agrega la URL
# real en CORS_ORIGINS dentro del .env, separada por comas.
ORIGENES = os.getenv("CORS_ORIGINS", "http://localhost:5173").split(",")

app.add_middleware(
    CORSMiddleware,
    allow_origins=ORIGENES,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/api/salud")
def salud():
    return {"estado": "ok"}
