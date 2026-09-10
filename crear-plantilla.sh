#!/usr/bin/env bash
# ---------------------------------------------------------------
# Semillero SINDES - FESC
# Crea el repo plantilla que usaran los 3 proyectos.
#
#   chmod +x crear-plantilla.sh
#   ./crear-plantilla.sh plantilla-proyecto
# ---------------------------------------------------------------
set -euo pipefail

DIR="${1:-plantilla-proyecto}"

if [ -e "$DIR" ]; then
  echo "Ya existe '$DIR'. Borralo o usa otro nombre."
  exit 1
fi

mkdir -p "$DIR"
cd "$DIR"

mkdir -p docs/img docs/bitacora docs/adr
mkdir -p backend/app backend/tests
mkdir -p frontend/src
mkdir -p db/migraciones
mkdir -p automations
mkdir -p .github/ISSUE_TEMPLATE

# Git no versiona carpetas vacias
touch docs/img/.gitkeep backend/tests/.gitkeep frontend/src/.gitkeep db/migraciones/.gitkeep

# ---------------------------------------------------------------
cat > README.md <<'MD'
# NOMBRE DEL PROYECTO

> Semillero de investigacion SINDES — FESC, Cucuta

Una sola frase: que problema resuelve y para quien.

## Equipo

| Rol | Integrante | Su rama |
|---|---|---|
| Lider | Neiber | `neiber` |
| Frontend | | |
| Backend | | |

## Estado

Sprint actual: —
Ultima demo: —

## Como correrlo

Backend:

```bash
cd backend
python -m venv .venv
source .venv/bin/activate        # Windows: .venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

Frontend:

```bash
cd frontend
npm install
npm run dev
```

Copia `.env.example` a `.env` y llena los valores. El `.env` real NUNCA se sube.

## Documentacion

| Documento | Que contiene |
|---|---|
| [00-vision](docs/00-vision.md) | Problema, alcance y que NO vamos a hacer |
| [01-requisitos](docs/01-requisitos.md) | Historias de usuario |
| [02-arquitectura](docs/02-arquitectura.md) | Como estan armadas las piezas |
| [03-api](docs/03-api.md) | El contrato entre frontend y backend |
| [04-datos](docs/04-datos.md) | Modelo de base de datos |
| [manual-usuario](docs/manual-usuario.md) | Como se usa, con capturas |
| [bitacora](docs/bitacora/) | Acta de cada miercoles |

## Como trabajamos

Las reglas completas estan en [AGENTS.md](AGENTS.md). Resumen:

- Una rama fija por integrante, mas `main`. Las ramas no se borran.
- Antes de empezar algo: `git pull origin main`
- Al terminar: commit, push, PR con `Closes #N`
- Despues del merge: `git pull origin main` y sigo en la misma rama
- Todo lo que va a la demo del miercoles debe estar mergeado el martes en la noche
MD

# ---------------------------------------------------------------
cat > .gitignore <<'MD'
# Entornos y secretos
.env
.env.local
*.env
!.env.example

# Python
__pycache__/
*.py[cod]
.venv/
venv/
.pytest_cache/

# Node
node_modules/
dist/
build/
.vite/

# Editor y sistema
.vscode/*
!.vscode/extensions.json
.idea/
.DS_Store
Thumbs.db

# Logs y base local
*.log
*.sqlite3
MD

# ---------------------------------------------------------------
cat > .env.example <<'MD'
# Copia este archivo como .env y llena los valores reales.
# El .env NUNCA se sube al repo.

DATABASE_URL=postgresql://usuario:clave@localhost:5432/nombre_bd
API_URL=http://localhost:8000
N8N_WEBHOOK_URL=
MD

# ---------------------------------------------------------------
cat > docs/00-vision.md <<'MD'
# Vision

## Problema
Que duele hoy, en dos o tres frases. Sin tecnicismos.

## Para quien
Quien es el usuario real. Rol, no nombre.

## Que va a hacer el sistema
- Funcion 1
- Funcion 2
- Funcion 3

## Que NO vamos a hacer
Lo mas importante del documento. Todo lo que quede aqui deja de discutirse.

- No haremos X
- No haremos Y

## Como sabemos que sirvio
Una senal medible u observable.
MD

# ---------------------------------------------------------------
cat > docs/01-requisitos.md <<'MD'
# Requisitos

Formato: como <rol>, quiero <accion>, para <beneficio>.

| ID | Historia | Prioridad | Estado |
|---|---|---|---|
| HU-01 | Como bodeguero, quiero registrar la entrada de material, para saber el stock real | Alta | Pendiente |
| HU-02 | | | |

Prioridad: Alta / Media / Baja.
Estado: Pendiente / En curso / Listo.

## Reglas de negocio
- RN-01: descripcion corta de la regla.
MD

# ---------------------------------------------------------------
cat > docs/02-arquitectura.md <<'MD'
# Arquitectura

## Piezas

| Pieza | Tecnologia | Responsable |
|---|---|---|
| Frontend | React | |
| Backend | Python (FastAPI) | |
| Base de datos | PostgreSQL | |
| Automatizaciones | n8n | |

## Diagrama
Pega la imagen en `docs/img/` y enlazala aqui.

![Arquitectura](img/arquitectura.png)

## Decisiones
Las decisiones tecnicas con su justificacion van en `docs/adr/`.
MD

# ---------------------------------------------------------------
cat > docs/03-api.md <<'MD'
# Contrato de API

Este documento se define ANTES de programar. Mientras el backend lo construye,
el frontend trabaja contra datos falsos con esta misma forma.

Base: `http://localhost:8000/api`

## GET /productos
Devuelve el listado de productos.

Respuesta 200:

```json
[
  { "id": 1, "nombre": "Bota cuero", "stock": 12 },
  { "id": 2, "nombre": "Tenis lona", "stock": 30 }
]
```

## POST /productos
Crea un producto.

Cuerpo:

```json
{ "nombre": "Bota cuero", "stock": 12 }
```

Respuesta 201: el producto creado, con su `id`.

## Errores
| Codigo | Cuando |
|---|---|
| 400 | Datos invalidos |
| 404 | No existe el recurso |
| 500 | Error del servidor |

## Cambios al contrato
Cualquier cambio se avisa en el canal y se aprueba en la reunion del miercoles.
Cambiar esto sin avisar rompe el trabajo del compañero.
MD

# ---------------------------------------------------------------
cat > docs/04-datos.md <<'MD'
# Modelo de datos

## Entidades

### productos
| Campo | Tipo | Notas |
|---|---|---|
| id | serial | PK |
| nombre | varchar(120) | obligatorio |
| stock | integer | por defecto 0 |
| creado_en | timestamp | por defecto now() |

## Diagrama entidad-relacion
![Modelo](img/modelo-datos.png)

## Notas
- El esquema vive en `db/schema.sql`.
- Cada cambio al esquema entra como archivo nuevo en `db/migraciones/`.
MD

# ---------------------------------------------------------------
cat > docs/manual-usuario.md <<'MD'
# Manual de usuario

Escrito para alguien que no sabe programar. Cada modulo se documenta
al terminarlo, no al final del proyecto.

## Que es esto
Una frase.

## Como entrar
Pasos numerados, con captura.

## Modulo: <nombre>
1. Paso uno.
2. Paso dos.

![Pantalla](img/pantalla-modulo.png)

## Problemas comunes
| Si pasa esto | Haga esto |
|---|---|
| | |
MD

# ---------------------------------------------------------------
cat > docs/bitacora/PLANTILLA.md <<'MD'
# Acta AAAA-MM-DD

Copia este archivo como `AAAA-MM-DD.md`. Un archivo por fecha, nunca uno compartido.

Asistentes:

## Lo que se mostro
- Integrante — que demostro — link al PR

## Bloqueos
| Quien | Bloqueo | Quien ayuda |
|---|---|---|

## Decisiones
- Decision y por que.

## Compromisos para el proximo miercoles
| Quien | Issue | Que entrega |
|---|---|---|
MD

# ---------------------------------------------------------------
cat > docs/adr/0001-plantilla.md <<'MD'
# ADR 0001 — Titulo de la decision

Fecha:
Estado: propuesta | aceptada | reemplazada

## Contexto
Que problema nos obligo a decidir.

## Opciones
- Opcion A
- Opcion B

## Decision
Escogimos X.

## Por que
Dos o tres razones.

## Que perdemos
Con que nos quedamos a cambio.
MD

# ---------------------------------------------------------------
cat > backend/README.md <<'MD'
# Backend

FastAPI + PostgreSQL.

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

Documentacion interactiva: http://localhost:8000/docs

El contrato que hay que respetar esta en `../docs/03-api.md`.
MD

cat > backend/requirements.txt <<'MD'
fastapi
uvicorn[standard]
psycopg[binary]
python-dotenv
pydantic
MD

cat > backend/app/main.py <<'MD'
from fastapi import FastAPI

app = FastAPI(title="Semillero SINDES")


@app.get("/api/salud")
def salud():
    return {"estado": "ok"}
MD

touch backend/app/__init__.py

# ---------------------------------------------------------------
cat > frontend/README.md <<'MD'
# Frontend

React + Vite.

```bash
npm install
npm run dev
```

Mientras el backend no este listo, se trabaja contra datos falsos
con la forma exacta de `../docs/03-api.md`.
MD

# ---------------------------------------------------------------
cat > db/README.md <<'MD'
# Base de datos

- `schema.sql` — esquema completo, siempre actualizado.
- `seed.sql` — datos de prueba para poder trabajar.
- `migraciones/` — un archivo por cambio: `001-crea-productos.sql`.

Nunca se edita una migracion ya aplicada. Se crea una nueva.
MD

cat > db/schema.sql <<'MD'
-- Esquema del proyecto. Ver docs/04-datos.md

CREATE TABLE IF NOT EXISTS productos (
    id          SERIAL PRIMARY KEY,
    nombre      VARCHAR(120) NOT NULL,
    stock       INTEGER NOT NULL DEFAULT 0,
    creado_en   TIMESTAMP NOT NULL DEFAULT NOW()
);
MD

cat > db/seed.sql <<'MD'
INSERT INTO productos (nombre, stock) VALUES
    ('Bota cuero', 12),
    ('Tenis lona', 30);
MD

# ---------------------------------------------------------------
cat > automations/README.md <<'MD'
# Automatizaciones (n8n)

Cada flujo se exporta desde n8n y se guarda aqui como `.json`,
para que quede versionado y cualquiera lo pueda importar.

| Archivo | Que hace | Cada cuanto |
|---|---|---|
| | | |

Los tokens y URLs no van en el JSON: van como credenciales dentro de n8n.
MD

# ---------------------------------------------------------------
cat > .github/ISSUE_TEMPLATE/tarea.md <<'MD'
---
name: Tarea
about: Un pedazo de trabajo de 2 a 4 horas
labels: tarea
---

## Que hay que hacer
Una frase.

## Como se sabe que quedo listo
- [ ]
- [ ]
- [ ] README o docs actualizados

## Tamaño
S (2h) / M (4h) / L (partir en varias)

## Depende de
#
MD

cat > .github/ISSUE_TEMPLATE/bug.md <<'MD'
---
name: Bug
about: Algo que no funciona
labels: bug
---

## Que pasa

## Que deberia pasar

## Como reproducirlo
1.
2.

## Error exacto o captura
MD

cat > .github/pull_request_template.md <<'MD'
## Que hace este PR

Closes #

## Como probarlo
1.
2.

## Checklist
- [ ] Hice `git pull origin main` antes de abrir el PR
- [ ] Respete el contrato de `docs/03-api.md`
- [ ] Actualice la documentacion si hizo falta
- [ ] El PR hace una sola cosa
- [ ] Puedo explicar cada linea de este PR (haya usado IA o no)
MD

# ---------------------------------------------------------------
cat > AGENTS.md <<'MD'
# AGENTS.md

Reglas de este proyecto. Las leen los agentes de IA (Copilot, Cursor, Claude Code,
Codex, Windsurf) y tambien cualquier integrante nuevo. Si algo cambia aqui,
se avisa en la reunion del miercoles.

## Que es esto

<UNA FRASE: que hace el sistema y para quien.>

Proyecto del semillero SINDES — FESC. Equipo de 2 a 3 estudiantes de segundo semestre.
El codigo tiene que quedar entendible por alguien que lleva seis meses programando.
Si hay que elegir entre elegante y obvio, se elige obvio.

## Stack

Es fijo. No se agregan librerias ni frameworks sin aprobarlo en la reunion.

- Backend: Python + FastAPI
- Frontend: React + Vite
- Base de datos: PostgreSQL
- Automatizaciones: n8n

```bash
cd backend  && uvicorn app.main:app --reload   # API en :8000
cd frontend && npm run dev                     # UI en :5173
```

## Reglas de negocio

Las reglas del dominio (que se puede y que no se puede hacer en el negocio)
viven en `docs/01-requisitos.md`, seccion "Reglas de negocio", numeradas RN-01, RN-02...

Antes de escribir logica, leelas. **Si una regla no esta escrita ahi, no la inventes:**
se pregunta en el canal o en la reunion, se escribe primero, y despues se programa.

## El contrato de API es sagrado

`docs/03-api.md` define que endpoints existen, que reciben y que devuelven.

- El backend implementa exactamente eso.
- El frontend consume exactamente eso.
- Nadie lo cambia por su cuenta. Se propone, se aprueba el miercoles, y se actualiza
  el `.md` ANTES de tocar codigo.

## Commits

Formato: `tipo: descripcion corta en minuscula`

| Tipo | Cuando |
|---|---|
| `feat` | funcionalidad nueva |
| `fix` | corrige algo que estaba roto |
| `docs` | solo documentacion |
| `refactor` | reordena codigo sin cambiar el comportamiento |
| `chore` | configuracion, dependencias, cosas del repo |

Asi si:
- `feat: agrega endpoint de productos`
- `fix: corrige calculo de stock negativo`

Asi no: `cambios`, `update`, `asdf`, `ya quedo`, `.`

## Ramas y pull requests

- Una rama fija por integrante (`neiber`, `maria`, `daniel`). **Nunca se borran.**
- Antes de empezar cualquier cosa: `git pull origin main`
- El PR hace UNA sola cosa y lleva `Closes #N` en la descripcion.
- Siempre merge commit. Nunca squash, nunca rebase.
- Jamas un commit directo a `main`.

## Estilo

- El dominio se nombra en español (`productos`, `stock`, `pedido`),
  lo tecnico en ingles (`get`, `router`, `handler`).
- Funciones cortas, que hagan una sola cosa.
- Comentarios solo donde el "por que" no sea evidente. No comentar lo que el codigo ya dice.
- Nada de `print` ni `console.log` de depuracion en lo que se mergea.

## Que NO hacer

- No inventar endpoints que no esten en `docs/03-api.md`.
- No meter credenciales, tokens ni URLs de produccion en el codigo. Van en `.env`.
- No editar migraciones ya aplicadas en `db/migraciones/`. Se crea un archivo nuevo.
- No entregar cambios de mas de ~300 lineas. Si crece, se parte en varios PR.
- No reescribir codigo de un compañero sin avisarle en el canal.

## Si usas IA para programar

Esta permitido y se espera que la usen. Pero con estas cuatro reglas:

1. **Si no puedes explicar el codigo, no lo mergeas.** En la demo del miercoles
   te pueden preguntar por cualquier linea.
2. Pidele cambios pequeños, no modulos completos de una.
3. Corre el codigo antes de commitear. La IA se equivoca, y se equivoca con seguridad.
4. Si un pedazo lo genero la IA, dilo en el PR. No es demerito, es trazabilidad,
   y este es un semillero de investigacion.
MD

cat > CLAUDE.md <<'MD'
# CLAUDE.md

Las reglas de este proyecto estan en [AGENTS.md](./AGENTS.md).
Leelo completo antes de proponer o escribir codigo.
MD

cat > .github/copilot-instructions.md <<'MD'
Las reglas de este proyecto estan en [AGENTS.md](../AGENTS.md).
Seguilas al generar codigo, commits o descripciones de pull request.
MD

# ---------------------------------------------------------------
echo "Listo: $DIR"
echo
echo "Siguiente:"
echo "  cd $DIR"
echo "  git init -b main"
echo "  git add ."
echo "  git commit -m 'chore: estructura base del proyecto'"
echo "  git remote add origin https://github.com/TU-ORG/plantilla-proyecto.git"
echo "  git push -u origin main"
