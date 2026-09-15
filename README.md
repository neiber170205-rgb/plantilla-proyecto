# NOMBRE DEL PROYECTO

Una sola frase: que problema resuelve y para quien.

## Equipo

| Rol | Integrante | Su rama |
|---|---|---|
| | | |
| | | |
| | | |

## Estado

Sprint actual: —
Ultima demo: —

## Stack

| Pieza | Tecnologia |
|---|---|
| Frontend | React + Vite + TypeScript, Tailwind CSS, shadcn/ui |
| Backend | Python + FastAPI |
| Base de datos | PostgreSQL (en Docker) |
| Automatizaciones | n8n |

## Requisitos

Tener instalados:

- **Docker** — https://docs.docker.com/get-docker/
- **Python 3.10+** — https://www.python.org/downloads/
- **Node 20+** — https://nodejs.org

## Instalacion

La primera vez, **un solo comando** desde la raiz:

```bash
bash setup.sh
```

Hace todo en orden: revisa Docker, crea el `.env`, levanta la base de datos,
instala el backend, instala el frontend y comprueba que el backend se conecta a
la base. Si falta algo, dice que y como arreglarlo. Correrlo dos veces no rompe nada.

> En Windows, correlo desde **Git Bash** o WSL.

## Arrancar

Cada vez que vayas a trabajar, en dos terminales:

```bash
# Terminal 1 — API en http://localhost:8000
cd backend
source .venv/bin/activate          # Windows: .venv\Scripts\activate
uvicorn app.main:app --reload

# Terminal 2 — interfaz en http://localhost:5173
cd frontend
npm run dev
```

La base queda corriendo en Docker. Para apagarla: `docker compose stop`.

Para comprobar que todo esta conectado:

```bash
curl http://localhost:8000/api/salud
# {"estado":"ok","bd":"ok","version":"1.0.0"}
```

## Estructura

```
.
├── setup.sh             instala todo el proyecto
├── docker-compose.yml   la base de datos
├── .env.example         variables de entorno (se copia a .env)
├── AGENTS.md            reglas del proyecto
├── frontend/            React + Vite          -> ver frontend/README.md
├── backend/             FastAPI               -> ver backend/README.md
├── db/                  SQL inicial y migraciones -> ver db/README.md
├── automations/         flujos de n8n
└── docs/                documentacion del proyecto
```

## Variables de entorno

Hay **un solo `.env`** para todo el proyecto, en la raiz. Lo crea `setup.sh` a
partir de `.env.example`. **El `.env` real nunca se sube al repo.**

Lo que no esta en el repo y se regenera con `setup.sh`: `frontend/node_modules/`,
`backend/.venv/` y el propio `.env`.

## Documentacion

| Documento | Que contiene |
|---|---|
| [00-vision](docs/00-vision.md) | Problema, alcance y que NO vamos a hacer |
| [01-requisitos](docs/01-requisitos.md) | Historias de usuario y reglas de negocio |
| [02-arquitectura](docs/02-arquitectura.md) | Como estan armadas las piezas |
| [03-api](docs/03-api.md) | El contrato entre frontend y backend |
| [04-datos](docs/04-datos.md) | Modelo de base de datos |
| [adr/](docs/adr/) | Decisiones tecnicas y por que se tomaron |
| [manual-usuario](docs/manual-usuario.md) | Como se usa, con capturas |
| [bitacora](docs/bitacora/) | Acta de cada reunion |

## Como trabajamos

Las reglas completas estan en [AGENTS.md](AGENTS.md). Resumen:

- Una rama fija por integrante, mas `main`. Las ramas no se borran.
- Antes de empezar algo: `git pull origin main`
- Al terminar: commit, push, PR con `Closes #N`
- Despues del merge: `git pull origin main` y sigo en la misma rama
