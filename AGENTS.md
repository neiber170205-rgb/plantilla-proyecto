# AGENTS.md

Reglas de este proyecto. Las leen los agentes de IA (Copilot, Cursor, Claude Code,
Codex, Windsurf) y tambien cualquier integrante nuevo. Si algo cambia aqui,
se avisa en la reunion del equipo.

## Que es esto

<UNA FRASE: que hace el sistema y para quien.>

El codigo tiene que quedar entendible por cualquier integrante del equipo,
incluido el que menos experiencia tiene.
Si hay que elegir entre elegante y obvio, se elige obvio.

## Stack

Es fijo. No se agregan librerias ni frameworks sin aprobarlo en la reunion del equipo.

- Backend: Python + FastAPI, con `psycopg` y SQL escrito a mano (sin ORM)
- Frontend: React + Vite + TypeScript, Tailwind CSS y shadcn/ui
- Base de datos: PostgreSQL, levantada con Docker
- Automatizaciones: n8n

```bash
bash setup.sh                                  # la primera vez: instala todo
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
- Nadie lo cambia por su cuenta. Se propone, se aprueba en la reunion, y se
  actualiza el `.md` ANTES de tocar codigo.

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
- `feat: agrega endpoint para listar registros`
- `fix: corrige la validacion del formulario`

Asi no: `cambios`, `update`, `asdf`, `ya quedo`, `.`

## Ramas y pull requests

- Una rama fija por integrante, con su nombre. **Nunca se borran.**
- Antes de empezar cualquier cosa: `git pull origin main`
- El PR hace UNA sola cosa y lleva `Closes #N` en la descripcion.
- Siempre merge commit. Nunca squash, nunca rebase.
- Jamas un commit directo a `main`.

## Estilo

- El dominio se nombra en español (entidades, tablas, campos del negocio),
  lo tecnico en ingles (`get`, `router`, `handler`, `loading`).
- Funciones cortas, que hagan una sola cosa.
- Comentarios solo donde el "por que" no sea evidente. No comentar lo que el codigo ya dice.
- Nada de `print` ni `console.log` de depuracion en lo que se mergea.

## Que NO hacer

- No inventar endpoints que no esten en `docs/03-api.md`.
- No meter credenciales, tokens ni URLs de produccion en el codigo. Van en `.env`.
- No editar migraciones ya aplicadas en `db/migraciones/`. Se crea un archivo nuevo.
- No entregar cambios de mas de ~300 lineas escritas a mano. Si crece, se parte en varios PR.
- No reescribir codigo de un compañero sin avisarle en el canal.

## Si usas IA para programar

Esta permitido. Pero con estas cuatro reglas:

1. **Si no puedes explicar el codigo, no lo mergeas.** En la demo te pueden
   preguntar por cualquier linea.
2. Pidele cambios pequeños, no modulos completos de una.
3. Corre el codigo antes de commitear. La IA se equivoca, y se equivoca con seguridad.
4. Si un pedazo lo genero la IA, dilo en el PR. No es demerito, es trazabilidad.
