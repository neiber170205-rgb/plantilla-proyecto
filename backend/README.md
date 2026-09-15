# Backend

Python + FastAPI + PostgreSQL, con `psycopg` y SQL escrito a mano. Sin ORM.

## Instalacion

Lo normal es instalar el proyecto entero desde la raiz, con un solo comando.
Ademas de instalar el backend, levanta la base de datos en Docker:

```bash
bash setup.sh
```

Si solo necesitas el backend, desde esta carpeta:

```bash
bash setup.sh
```

Ese script revisa que tengas **Python 3.10 o mas nuevo**, crea el entorno
virtual en `.venv/`, instala `requirements.txt` y crea el `.env` de la raiz si no
existe. La base tiene que estar arriba aparte: `docker compose up -d` desde la raiz.

`.venv/` no se sube al repo: se regenera con el script.

## Arrancar

```bash
source .venv/bin/activate          # Windows: .venv\Scripts\activate
uvicorn app.main:app --reload
```

| Direccion | Que hay |
|---|---|
| http://localhost:8000/api/salud | comprueba backend y base |
| http://localhost:8000/docs | documentacion interactiva de la API |

## Estructura

```
backend/
├── setup.sh             instala todo lo necesario
├── requirements.txt     dependencias de Python
├── app/
│   ├── main.py          crea la app, CORS, /api/salud y monta los routers
│   ├── db.py            la conexion a la base (lo unico que sabe conectarse)
│   ├── routers/         endpoints, un archivo por recurso
│   ├── schemas/         modelos de Pydantic: que entra y que sale
│   └── queries/         el SQL, una funcion por consulta
└── tests/               pruebas
```

| Carpeta | Que va |
|---|---|
| `app/routers/` | los endpoints. Reciben la peticion, llaman a `queries/` y responden |
| `app/schemas/` | clases de Pydantic con la forma exacta de `docs/03-api.md` |
| `app/queries/` | funciones con el SQL. Son las unicas que usan `get_connection()` |
| `tests/` | pruebas |

## Agregar un endpoint

1. Que ya este escrito y aprobado en `docs/03-api.md`.
2. Los modelos de entrada y salida en `app/schemas/<recurso>.py`.
3. El SQL en `app/queries/<recurso>.py`.
4. El endpoint en `app/routers/<recurso>.py`, con un `APIRouter`.
5. Montarlo en `app/main.py`:

```python
from app.routers.recurso import router as router_recurso

app.include_router(router_recurso)
```

## La conexion a la base

Vive solo en `app/db.py`, que lee `DATABASE_URL` del `.env` de la raiz. Ningun
otro archivo arma la conexion por su cuenta: el dia que la base cambie de lugar,
se cambia esa variable y no se toca codigo.

Se usa siempre con `with`, asi la conexion se cierra sola aunque la consulta falle:

```python
from app.db import get_connection

with get_connection() as conexion:
    with conexion.cursor() as cursor:
        cursor.execute("SELECT ... WHERE id = %s", (id,))
        filas = cursor.fetchall()
```

Los valores van **siempre** como parametros (`%s`), nunca pegados al texto del
SQL: eso es lo que evita la inyeccion SQL.

## /api/salud

| Respuesta | Que significa |
|---|---|
| `200` `{"estado":"ok","bd":"ok","version":"1.0.0"}` | backend arriba y base conectada |
| `503` `{"bd":"sin conexion", ...}` | la base no responde: `docker compose ps` |

## Errores: 400, no 422

FastAPI responde **422** por su cuenta cuando el cuerpo de una peticion no cuadra.
`app/main.py` lo convierte en **400**, que es lo que declara la tabla "Errores" de
`docs/03-api.md`. Aplica a todos los endpoints: no lo quites.

## Variables de entorno

Salen del `.env` de la **raiz del repo**.

| Variable | Para que |
|---|---|
| `DATABASE_URL` | conexion a PostgreSQL |
| `CORS_ORIGINS` | desde que direcciones acepta peticiones (separadas por comas) |
