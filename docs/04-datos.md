# Modelo de datos

Se llena cuando el equipo defina su dominio. Mientras tanto hay un ejemplo
completo en [ejemplo-contrato.md](ejemplo-contrato.md), con su tabla real en
`db/init/01-ejemplo.sql`.

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
- El SQL que este en `db/init/` se aplica **solo la primera vez**, cuando Docker
  crea el volumen vacio. Para volver a aplicarlo desde cero:
  `docker compose down -v && docker compose up -d` (esto borra los datos).
- Cada cambio posterior al esquema entra como archivo nuevo en `db/migraciones/`.
- Nunca se edita una migracion ya aplicada. Se crea una nueva.
