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
