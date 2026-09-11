# Base de datos

PostgreSQL, levantado con Docker desde la raiz del repo:

```bash
docker compose up -d      # la prende
docker compose ps         # ver si esta sana
docker compose stop       # la apaga sin borrar nada
```

No se instala Postgres a mano. Si no tienes Docker, `setup.sh` te lo dice.

## Donde va el SQL

| Carpeta | Que es | Cuando se aplica |
|---|---|---|
| `init/` | el esquema inicial y sus datos de prueba | **solo la primera vez**, cuando Docker crea el volumen vacio |
| `migraciones/` | un archivo por cada cambio posterior | a mano, en orden |

Los archivos de `init/` corren en orden alfabetico, por eso van numerados
(`01-`, `02-`...).

**`init/` tiene que existir siempre**, aunque quede vacia: si borras la carpeta,
`docker compose up` falla. Por eso tiene un `.gitkeep`.

## Ojo con esto

Cambiar un archivo de `init/` **no hace nada** si la base ya existe: ese SQL solo
corre cuando el volumen se crea. Para volver a aplicarlo desde cero:

```bash
docker compose down -v && docker compose up -d
```

El `-v` borra el volumen, o sea **borra todos los datos**. En desarrollo no pasa
nada; con datos que te importen, no lo corras.

## Migraciones

Una por cambio: `001-agrega-columna-color.sql`, `002-...`.

Nunca se edita una migracion ya aplicada. Se crea una nueva.

## El ejemplo

`init/01-ejemplo.sql` es del ejemplo borrable que trae la plantilla
(ver `docs/ejemplo-contrato.md`). Cuando el equipo defina su dominio, se borra
ese archivo y se pone el esquema real en `init/`.
