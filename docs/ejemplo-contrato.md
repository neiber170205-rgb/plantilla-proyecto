# Contrato del EJEMPLO borrable

> Este documento NO es el contrato del proyecto. Es el del ejemplo que trae la
> plantilla para mostrar el patron completo.
> El contrato de verdad se escribe en [03-api.md](03-api.md).
>
> Cuando el equipo defina su dominio, este archivo se borra junto con el resto
> del ejemplo (ver el README de la raiz).

Base: `http://localhost:8000/api`

## El dominio: inventario de calzado

Una sola tabla, `variantes`.

**Lo que enseña, y por eso se eligio asi:** en calzado el stock **no vive en la
referencia, vive en la variante**. La misma bota en talla 38 negra y en talla 40
cafe son dos inventarios distintos. Modelarlo al reves es el error clasico del
sector y obliga a rehacer media base de datos despues.

| Campo | Tipo | Notas |
|---|---|---|
| `id` | serial | PK |
| `referencia` | varchar(120) | el modelo, ej: "Bota chelsea cuero" |
| `talla` | integer | |
| `color` | varchar(40) | |
| `stock` | integer | por defecto 0 |
| `creado_en` | timestamp | por defecto `now()` |

El esquema y los datos de prueba estan en `db/init/01-ejemplo.sql`.

## GET /ejemplo/variantes

Devuelve el listado de variantes.

Respuesta 200:

```json
[
  { "id": 1, "referencia": "Bota chelsea cuero", "talla": 38, "color": "negro", "stock": 12 },
  { "id": 2, "referencia": "Bota chelsea cuero", "talla": 40, "color": "cafe", "stock": 5 }
]
```

Fijate como las dos filas comparten `referencia` y cada una lleva su propio `stock`.

## POST /ejemplo/variantes

Crea una variante.

Cuerpo:

```json
{ "referencia": "Bota chelsea cuero", "talla": 38, "color": "negro", "stock": 12 }
```

Respuesta 201: la variante creada, con su `id`.

## Errores

| Codigo | Cuando |
|---|---|
| 400 | Datos invalidos |
| 404 | No existe el recurso |
| 500 | Error del servidor |

FastAPI responde 422 por su cuenta cuando el cuerpo no cuadra. El backend lo
traduce a 400 en `backend/app/main.py`, porque es lo que declara esta tabla y es
lo que el frontend tiene copiado en `getErrorMessage`.

## Donde esta implementado

| Parte | Archivo |
|---|---|
| Backend | `backend/app/ejemplo/router.py` |
| Tabla y datos | `db/init/01-ejemplo.sql` |
| Cliente del frontend | `frontend/src/ejemplo/api.ts` |
| Pantalla | `frontend/src/ejemplo/index.tsx` |
| Formulario | `frontend/src/ejemplo/VarianteForm.tsx` |
