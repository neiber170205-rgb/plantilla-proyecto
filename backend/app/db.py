"""Lo unico que sabe como conectarse a la base de datos.

Si manana la base se muda al servidor, se cambia DATABASE_URL en el .env
y este archivo no se toca. Ningun otro archivo arma la conexion por su cuenta.
"""

import os
from pathlib import Path

import psycopg
from dotenv import load_dotenv

# El .env es uno solo para todo el proyecto y vive en la raiz del repo.
load_dotenv(Path(__file__).resolve().parents[2] / ".env")

# El valor por defecto es el mismo que levanta docker-compose.yml, para que esto
# funcione recien clonado aunque nadie haya tocado el .env todavia.
DATABASE_URL = os.getenv(
    "DATABASE_URL", "postgresql://sindes:sindes@localhost:5432/sindes"
)


def get_connection():
    """Abre una conexion nueva.

    Usala siempre con 'with', asi se cierra sola aunque la consulta falle:

        with get_connection() as conexion:
            with conexion.cursor() as cursor:
                cursor.execute("SELECT ...")
                filas = cursor.fetchall()
    """
    return psycopg.connect(DATABASE_URL)


def check_database():
    """Comprueba que la base responde. Lanza excepcion si no.

    Es a proposito lo mas barato posible: no lee ninguna tabla, solo le pide a
    Postgres que devuelva un 1. Lo usa /api/salud, que se llama muy seguido.
    """
    with get_connection() as conexion:
        with conexion.cursor() as cursor:
            cursor.execute("SELECT 1")
