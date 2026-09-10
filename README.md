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

La primera vez, un comando por cada lado. Cada uno instala TODO lo que necesita
y te deja el `.env` creado:

```bash
cd backend  && bash setup.sh
cd frontend && bash setup.sh
```

Despues, cada vez que vayas a trabajar, en dos terminales:

```bash
cd backend  && source .venv/bin/activate && uvicorn app.main:app --reload   # API en :8000
cd frontend && npm run dev                                                  # UI en :5173
```

Y abre http://localhost:5173

El `.env` es UNO SOLO para todo el proyecto y vive en la raiz. Lo crean los
`setup.sh` a partir de `.env.example`; revisa que los valores sean los tuyos.
El `.env` real NUNCA se sube.

Lo que NO esta en el repo y por eso hay que instalarlo: `frontend/node_modules/`
y `backend/.venv/`. Se regeneran solos con los `setup.sh`, no los subas.

La UI arranca con datos falsos, asi que se ve aunque el backend no este listo.
Como conectarla de verdad esta en [frontend/README.md](frontend/README.md).

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
