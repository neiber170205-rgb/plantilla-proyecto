"""EJEMPLO BORRABLE — no construyas tu dominio encima de este archivo.

Esto existe para mostrar el patron completo: una tabla, dos endpoints, SQL
escrito a mano. Cuando el equipo defina su dominio real, se copia el patron
a un archivo nuevo y esta carpeta se borra entera.

El contrato que implementa esta en docs/ejemplo-contrato.md.
"""

import psycopg
from fastapi import APIRouter, HTTPException, status
from pydantic import BaseModel

from app.db import get_connection

# El prefijo /api/ejemplo los delata a proposito: nadie los confunde con
# los endpoints de verdad del proyecto.
router = APIRouter(prefix="/api/ejemplo", tags=["ejemplo"])


class Variante(BaseModel):
    id: int
    referencia: str
    talla: int
    color: str
    stock: int


class NuevaVariante(BaseModel):
    referencia: str
    talla: int
    color: str
    stock: int


@router.get("/variantes")
def get_variantes() -> list[Variante]:
    """GET /api/ejemplo/variantes -> 200 con la lista."""
    try:
        with get_connection() as conexion:
            with conexion.cursor() as cursor:
                cursor.execute(
                    "SELECT id, referencia, talla, color, stock "
                    "FROM variantes ORDER BY referencia, talla"
                )
                filas = cursor.fetchall()
    except psycopg.Error:
        raise HTTPException(status_code=500, detail="Error del servidor")

    # psycopg devuelve tuplas; el orden es el mismo del SELECT de arriba.
    return [
        Variante(id=fila[0], referencia=fila[1], talla=fila[2], color=fila[3], stock=fila[4])
        for fila in filas
    ]


@router.post("/variantes", status_code=status.HTTP_201_CREATED)
def post_variante(nueva: NuevaVariante) -> Variante:
    """POST /api/ejemplo/variantes -> 201 con la variante creada, ya con su id.

    El RETURNING de Postgres devuelve la fila recien insertada en la misma
    consulta, asi no hay que volver a preguntarle el id.
    """
    try:
        with get_connection() as conexion:
            with conexion.cursor() as cursor:
                cursor.execute(
                    "INSERT INTO variantes (referencia, talla, color, stock) "
                    "VALUES (%s, %s, %s, %s) "
                    "RETURNING id, referencia, talla, color, stock",
                    (nueva.referencia, nueva.talla, nueva.color, nueva.stock),
                )
                fila = cursor.fetchone()
    except psycopg.Error:
        raise HTTPException(status_code=500, detail="Error del servidor")

    return Variante(
        id=fila[0], referencia=fila[1], talla=fila[2], color=fila[3], stock=fila[4]
    )
