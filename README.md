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

La primera vez, **un solo comando** desde la raiz. Instala todo: levanta la base
de datos, arma el backend, instala el frontend y comprueba que se hablan entre si.

```bash
bash setup.sh
```

Necesitas tener instalados **Docker**, **Python 3.10+** y **Node 20+**.
Si te falta alguno, el script te dice cual y donde bajarlo.

Despues, cada vez que vayas a trabajar, en dos terminales:

```bash
cd backend  && source .venv/bin/activate && uvicorn app.main:app --reload   # API en :8000
cd frontend && npm run dev                                                  # UI en :5173
```

Y abre http://localhost:5173

La base queda corriendo sola en Docker. Para apagarla: `docker compose stop`.

El `.env` es UNO SOLO para todo el proyecto y vive en la raiz. Lo crea `setup.sh`
a partir de `.env.example`. El `.env` real NUNCA se sube.

Lo que NO esta en el repo y por eso hay que instalarlo: `frontend/node_modules/`
y `backend/.venv/`. Se regeneran con `setup.sh`, no los subas.

## El ejemplo se borra

La plantilla trae un ejemplo completo y funcionando —inventario de calzado— para
mostrar el patron: una tabla, dos endpoints, una pantalla. **No construyas tu
proyecto encima de el.** Copia el patron y borralo.

Cuando definan su dominio, borren el ejemplo completo:

```bash
git rm -r frontend/src/ejemplo backend/app/ejemplo docs/ejemplo-contrato.md
git rm db/init/01-ejemplo.sql
```

Despues de eso el proyecto sigue compilando y `/api/salud` sigue respondiendo:
no hay que tocar ningun otro archivo. La pantalla queda con un recuadro que dice
donde va la primera pantalla de ustedes.

El contrato del ejemplo esta en [docs/ejemplo-contrato.md](docs/ejemplo-contrato.md).
El de ustedes va en [docs/03-api.md](docs/03-api.md), que esta vacio esperandolos.

## Comprobar que todo esta bien

```bash
curl http://localhost:8000/api/salud
```

Si responde `{"estado":"ok","bd":"ok","version":"1.0.0"}`, la tuberia completa
funciona: backend arriba y base conectada. Si responde 503, la base esta caida:
`docker compose ps` para ver como esta.

## Documentacion

| Documento | Que contiene |
|---|---|
| [00-vision](docs/00-vision.md) | Problema, alcance y que NO vamos a hacer |
| [01-requisitos](docs/01-requisitos.md) | Historias de usuario |
| [02-arquitectura](docs/02-arquitectura.md) | Como estan armadas las piezas |
| [03-api](docs/03-api.md) | El contrato entre frontend y backend |
| [04-datos](docs/04-datos.md) | Modelo de base de datos |
| [ejemplo-contrato](docs/ejemplo-contrato.md) | El contrato del ejemplo borrable (se va con el) |
| [adr/](docs/adr/) | Decisiones tecnicas y por que se tomaron |
| [manual-usuario](docs/manual-usuario.md) | Como se usa, con capturas |
| [bitacora](docs/bitacora/) | Acta de cada miercoles |

## Como trabajamos

Las reglas completas estan en [AGENTS.md](AGENTS.md). Resumen:

- Una rama fija por integrante, mas `main`. Las ramas no se borran.
- Antes de empezar algo: `git pull origin main`
- Al terminar: commit, push, PR con `Closes #N`
- Despues del merge: `git pull origin main` y sigo en la misma rama
- Todo lo que va a la demo del miercoles debe estar mergeado el martes en la noche
