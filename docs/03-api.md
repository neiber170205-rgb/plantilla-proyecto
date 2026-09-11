# Contrato de API

Este documento se define ANTES de programar. Mientras el backend lo construye,
el frontend trabaja contra datos falsos con esta misma forma.

Es el contrato del proyecto. Se llena cuando el equipo defina su dominio.
Mientras tanto, hay un ejemplo completo y funcionando en
[ejemplo-contrato.md](ejemplo-contrato.md): usalo de molde, no construyas encima.

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

Esta tabla no se cambia: el frontend la tiene copiada en `getErrorMessage`.

| Codigo | Cuando |
|---|---|
| 400 | Datos invalidos |
| 404 | No existe el recurso |
| 500 | Error del servidor |

## Cambios al contrato

Cualquier cambio se avisa en el canal y se aprueba en la reunion del miercoles.
Cambiar esto sin avisar rompe el trabajo del compañero.

El orden es siempre este, nunca al reves:

1. Se propone y se aprueba el miercoles.
2. Se actualiza este documento.
3. Se cambia el backend.
4. Se cambia el cliente del frontend.
5. Se cambia la pantalla.
