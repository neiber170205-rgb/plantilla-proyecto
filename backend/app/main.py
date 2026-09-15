import os
from pathlib import Path

from dotenv import load_dotenv
from fastapi import FastAPI, Request, Response
from fastapi.exceptions import RequestValidationError
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from app.db import check_database

# El .env es uno solo para todo el proyecto y vive en la raiz del repo.
load_dotenv(Path(__file__).resolve().parents[2] / ".env")

VERSION = "1.0.0"

app = FastAPI(title="API", version=VERSION)

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


@app.exception_handler(RequestValidationError)
def datos_invalidos(request: Request, exc: RequestValidationError):
    """Convierte el 422 de FastAPI en el 400 que declara docs/03-api.md.

    Cuando el cuerpo de una peticion no cuadra, FastAPI responde 422 por su
    cuenta. El contrato de la API solo declara 400/404/500, asi que el
    frontend nunca tiene que saber que existe el 422.
    """
    return JSONResponse(status_code=400, content={"detail": "Datos invalidos"})


@app.get("/api/salud")
def salud(response: Response):
    """Si esto responde bien, el backend esta arriba y conectado a la base."""
    try:
        check_database()
    except Exception:
        # A proposito no se devuelve el error de Python: una traza no le dice a
        # nadie que hacer, este mensaje si.
        response.status_code = 503
        return {
            "estado": "degradado",
            "bd": "sin conexion",
            "version": VERSION,
            "mensaje": (
                "No se pudo conectar a la base de datos. "
                "Revisa que este arriba con: docker compose ps"
            ),
        }

    return {"estado": "ok", "bd": "ok", "version": VERSION}


# Aqui se montan los routers de app/routers/. Por cada archivo nuevo:
#
#   from app.routers.nombre import router as router_nombre
#   app.include_router(router_nombre)
