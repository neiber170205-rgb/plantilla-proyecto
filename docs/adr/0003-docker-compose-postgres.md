# ADR 0003 — PostgreSQL con Docker Compose

Fecha: 2026-09-11
Estado: propuesta

Queda como **propuesta** hasta que se apruebe en la reunion. AGENTS.md exige
aprobar herramientas nuevas el miercoles. Si no se aprueba, se revierte: se
borra `docker-compose.yml` y cada quien instala Postgres a mano en su maquina.

## Contexto

De esta plantilla van a nacer tres proyectos distintos, con equipos de segundo
semestre. Todos necesitan PostgreSQL corriendo antes de escribir una sola linea.

Instalar Postgres a mano en Windows, Mac y Linux son tres procedimientos
distintos, cada uno con su forma de crear el usuario, la base y de arrancar el
servicio. Es la clase de problema que se come una sesion entera del semillero y
que ademas deja a cada integrante con una version distinta.

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

- Con la opcion A, "me falla la base" iba a ser la pregunta de todas las
  reuniones, y con una respuesta distinta segun el sistema operativo de cada uno.
- Un solo comando (`docker compose up -d`) da la misma version de Postgres, el
  mismo usuario y la misma base a los tres proyectos y a todas las maquinas.
- La opcion C suena mas completa, pero mete a segundo semestre a depurar
  recarga en caliente dentro de contenedores y volumenes montados. El costo de
  aprendizaje no lo paga.
- El `healthcheck` permite que `setup.sh` espere a que la base **acepte
  conexiones de verdad**, no solo a que el contenedor exista. Sin eso, el primer
  arranque falla por una carrera de tiempos y parece un error del codigo.
- Las credenciales salen del `.env`. El dia que la base viva en el servidor de
  la nube, se apaga el contenedor y se cambia `DATABASE_URL`: nada mas.

## Que perdemos

- **Una herramienta nueva que instalar.** Docker Desktop pesa y en Windows pide
  WSL2. Es el costo mas real de esta decision.
- El SQL de `db/init/` corre **solo la primera vez**, cuando el volumen se crea.
  Es una fuente de confusion garantizada: cambias el archivo, no pasa nada, y
  hay que explicar `docker compose down -v`. Quedo documentado en `db/README.md`.
- Un puerto mas que se puede chocar. Si alguien ya tiene Postgres en el 5432, hay
  que cambiar `POSTGRES_PORT` en el `.env`. Por eso el puerto es configurable y
  no esta quemado en el `docker-compose.yml`.
