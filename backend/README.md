# Backend

FastAPI + PostgreSQL, con `psycopg` y SQL escrito a mano. **Sin ORM**: estan
aprendiendo SQL y un ORM esconde justo lo que hay que ver.

```bash
source .venv/bin/activate        # Windows: .venv\Scripts\activate
uvicorn app.main:app --reload
```

La instalacion la hace `bash ../setup.sh` desde la raiz, que instala todo el
proyecto y levanta la base. Si solo quieres el backend: `bash setup.sh`
(la base tiene que estar arriba: `docker compose up -d` desde la raiz).

Documentacion interactiva: http://localhost:8000/docs

## Que hay aca

| Archivo | Que hace | Se toca |
|---|---|---|
| `app/main.py` | arranca la app, CORS, `/api/salud` | Si, para montar tus routers |
| `app/db.py` | **lo unico que sabe conectarse a la base** | No |

## /api/salud

Es el "hola mundo" de la plantilla. Si responde bien, la tuberia entera sirve.
No tiene nada de dominio, asi que se queda para siempre.

```bash
curl http://localhost:8000/api/salud
```

| Respuesta | Que significa |
|---|---|
| `200` con `{"estado":"ok","bd":"ok","version":"1.0.0"}` | todo bien |
| `503` con `"bd":"sin conexion"` | la base no responde: `docker compose ps` |

## La conexion a la base

Vive solo en `app/db.py`, que lee `DATABASE_URL` del `.env` de la raiz.
Ningun otro archivo arma la conexion por su cuenta. El dia que la base se mude
al servidor, se cambia esa variable y no se toca codigo.

Para consultar se usa siempre con `with`, asi la conexion se cierra sola:

```python
from app.db import get_connection

with get_connection() as conexion:
    with conexion.cursor() as cursor:
        cursor.execute("SELECT id, nombre FROM tu_tabla")
        filas = cursor.fetchall()
```

## Cuidado con el 422

FastAPI responde **422** por su cuenta cuando el cuerpo de una peticion no cuadra,
pero nuestros contratos solo declaran 400/404/500 y el frontend tiene esa tabla
copiada. `main.py` traduce el 422 a **400**. Si agregas endpoints, esa traduccion
ya aplica a todos: no la quites.

## El contrato

El del proyecto esta en `../docs/03-api.md` y hay que respetarlo exactamente.
No se inventan endpoints ni reglas de negocio: si una regla no esta escrita en
`../docs/01-requisitos.md`, se pregunta primero y se escribe antes de programar.
