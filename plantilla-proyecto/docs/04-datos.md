# Modelo de datos

## Entidades

### productos
| Campo | Tipo | Notas |
|---|---|---|
| id | serial | PK |
| nombre | varchar(120) | obligatorio |
| stock | integer | por defecto 0 |
| creado_en | timestamp | por defecto now() |

## Diagrama entidad-relacion
![Modelo](img/modelo-datos.png)

## Notas
- El esquema vive en `db/schema.sql`.
- Cada cambio al esquema entra como archivo nuevo en `db/migraciones/`.
