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
