# Contrato de API

Este documento se define ANTES de programar. Mientras el backend lo construye,
el frontend trabaja contra datos falsos con esta misma forma.

Base: `http://localhost:8000/api`

## GET /<recurso>

Que devuelve, en una frase.

Respuesta 200:

```json
[]
```

## POST /<recurso>

Que crea, en una frase.

Cuerpo:

```json
{}
```

Respuesta 201: el recurso creado, con su `id`.

## Errores

| Codigo | Cuando |
|---|---|
| 400 | Datos invalidos |
| 404 | No existe el recurso |
| 500 | Error del servidor |

El backend ya convierte el 422 de FastAPI en 400 (ver `backend/app/main.py`).

## Cambios al contrato

Cualquier cambio se avisa en el canal y se aprueba en la reunion del equipo.
Cambiar esto sin avisar rompe el trabajo del compañero.

El orden es siempre este, nunca al reves:

1. Se propone y se aprueba en la reunion.
2. Se actualiza este documento.
3. Se cambia el backend.
4. Se cambia el servicio del frontend (`frontend/src/services/`).
5. Se cambia la pantalla.
