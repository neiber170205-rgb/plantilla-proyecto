# ADR 0003 — PostgreSQL con Docker Compose

Fecha:
Estado: aceptada

## Contexto

Todo el equipo necesita PostgreSQL corriendo antes de escribir una sola linea.

Instalar Postgres a mano en Windows, Mac y Linux son tres procedimientos distintos,
cada uno con su forma de crear el usuario, la base y de arrancar el servicio. Es el
tipo de problema que se come una sesion entera y ademas deja a cada integrante con
una version distinta.

## Opciones

- **A. Cada quien instala Postgres en su maquina.** Cero herramientas nuevas.
- **B. Postgres en Docker, solo la base.** El backend y el frontend siguen
  corriendo nativos.
- **C. Todo en Docker** (base, backend y frontend).

## Decision

Escogimos B: un `docker-compose.yml` en la raiz con **un solo servicio**, la base.

El backend y el frontend **no** se containerizan: se corren nativos con
`uvicorn --reload` y `npm run dev`, que es como se trabaja todos los dias.

## Por que

- Con la opcion A, "me falla la base" se vuelve la pregunta de siempre, con una
  respuesta distinta segun el sistema operativo de cada uno.
- Un solo comando (`docker compose up -d`) da la misma version de Postgres, el mismo
  usuario y la misma base en todas las maquinas.
- La opcion C obliga a depurar recarga en caliente dentro de contenedores y volumenes
  montados. El costo de aprendizaje no lo paga.
- El `healthcheck` permite que `setup.sh` espere a que la base **acepte conexiones de
  verdad**, no solo a que el contenedor exista.
- Las credenciales salen del `.env`. El dia que la base viva en un servidor, se apaga
  el contenedor y se cambia `DATABASE_URL`: nada mas.

## Que perdemos

- **Una herramienta mas que instalar.** Docker Desktop pesa y en Windows pide WSL2.
- El SQL de `db/init/` corre **solo la primera vez**, cuando el volumen se crea. Si
  cambias el archivo despues, no pasa nada hasta `docker compose down -v`.
  Quedo documentado en `db/README.md`.
- Un puerto que se puede chocar. Si ya hay un Postgres en el 5432, se cambia
  `POSTGRES_PORT` en el `.env`. Por eso el puerto no esta quemado en el compose.
