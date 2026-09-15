# Modelo de datos

## Entidades

### <nombre_de_la_tabla>
| Campo | Tipo | Notas |
|---|---|---|
| id | serial | PK |
| | | |

## Diagrama entidad-relacion
![Modelo](img/modelo-datos.png)

## Notas

- La base la levanta `docker-compose.yml`. No se instala Postgres a mano.
- El esquema inicial va en `db/init/`. Ese SQL se aplica **solo la primera vez**,
  cuando Docker crea el volumen vacio. Para volver a aplicarlo desde cero:
  `docker compose down -v && docker compose up -d` (esto borra los datos).
- Cada cambio posterior al esquema entra como archivo nuevo en `db/migraciones/`.
- Nunca se edita una migracion ya aplicada. Se crea una nueva.
