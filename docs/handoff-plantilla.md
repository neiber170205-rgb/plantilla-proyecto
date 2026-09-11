# Contexto: dejar la plantilla ejecutable con un comando — SINDES (FESC)

Documento de traspaso. Continúa el trabajo del frontend, que ya está hecho.

Repo: `https://github.com/neiber170205-rgb/plantilla-proyecto`
Semillero de investigación SINDES — FESC, Cúcuta.
De esta plantilla van a nacer **3 proyectos completamente distintos**, cada uno
con equipos de 2 a 3 estudiantes de **segundo semestre** (~6 meses programando).

---

## 1. La tarea, en una frase

Que en un clon limpio, en una máquina que nunca vio el proyecto, **un solo
comando deje todo instalado y corriendo**.

```bash
git clone <repo> && cd plantilla-proyecto
bash setup.sh
```

Y después, en dos terminales, la aplicación levanta y la página carga sin
errores. Sin que nadie instale PostgreSQL a mano, sin que nadie edite un
archivo, sin que nadie tenga que preguntar nada.

Ese es el único criterio de éxito de esta tarea.

---

## 2. La línea que no se debe cruzar

Esto es una **plantilla**. Los 3 proyectos que nacerán de ella tienen dominios
sin relación entre sí.

| Sí va en la plantilla | NO va en la plantilla |
|---|---|
| Que arranque y corra | Los endpoints de un negocio |
| Conexión a Postgres verificada | Las tablas de un negocio |
| CORS, `.env`, dependencias | Las reglas de negocio |
| `setup.sh` que reproduce todo | Las pantallas del producto final |
| Un ejemplo **cercado y borrable** | Un ejemplo mezclado con el código base |

La plantilla prueba que **la tubería funciona**. Qué pasa por la tubería lo
define cada equipo con su empresa.

Si estás a punto de escribir lógica que solo tiene sentido para un negocio
concreto, y no está dentro de una carpeta `ejemplo/`, te saliste del alcance.

---

## 3. Reglas del repo (de `AGENTS.md`, no negociables)

- **Stack fijo:** Python + FastAPI, React + Vite, PostgreSQL, n8n.
  No se agregan librerías sin aprobarlo en la reunión del miércoles.
  **Nada de ORM** (SQLAlchemy, Alembic, SQLModel). Se usa `psycopg` con SQL
  escrito a mano, que ya está en `requirements.txt`. Razón pedagógica: están
  aprendiendo SQL y un ORM les esconde justo lo que tienen que ver.
- **Obvio sobre elegante.** "El código tiene que quedar entendible por alguien
  que lleva seis meses programando."
- **Nombres:** dominio en español (`variantes`, `stock`, `talla`),
  lo técnico en inglés (`get`, `router`, `handler`, `loading`).
- **Nada de credenciales, hosts ni puertos en el código.** Todo sale del `.env`.
- **Nada de `print` ni `console.log`** de depuración en lo que se mergea.
- **Commits:** `tipo: descripcion corta en minuscula`
  (`feat`, `fix`, `docs`, `refactor`, `chore`).
- **Ramas:** una fija por integrante (`neiber`), nunca se borran, nunca commit
  directo a `main`, siempre merge commit.
- **Un PR hace UNA sola cosa.** Máximo ~300 líneas escritas a mano (no cuentan
  archivos de bloqueo ni componentes generados por herramientas).

---

## 4. Estado actual

### Ya funciona

| Parte | Estado |
|---|---|
| Frontend | React 19 + Vite 8 + Tailwind 4 + shadcn (radix-nova) + lucide. Compila y corre |
| Cliente API | `src/api/productos.ts` — único archivo que habla con el backend |
| Pantalla | Maneja los 3 estados: cargando / error / datos, con botón Reintentar |
| CORS | `CORSMiddleware` leyendo `CORS_ORIGINS` del `.env` |
| `backend/setup.sh` | Probado. Crea `.venv`, instala, crea el `.env` |
| `frontend/setup.sh` | Probado en clon limpio. Instala y compila |
| Backend | Solo `GET /api/salud`, que devuelve `{"estado": "ok"}` |

### Falta (esta tarea)

1. PostgreSQL levantable con un comando
2. `/api/salud` que además verifique la base
3. Un `setup.sh` en la raíz que lo haga todo
4. Cercar el ejemplo actual y convertirlo en un ejemplo **real y borrable**

---

## 5. Trabajo 1 — PostgreSQL con Docker Compose

Un `docker-compose.yml` en la raíz, con **solo** el servicio de la base.
Nada de backend ni frontend containerizados: esos corren nativos, que es como
los estudiantes van a trabajar día a día.

Requisitos:

- Puerto `5432` publicado solo en `127.0.0.1`, no en `0.0.0.0`.
- Usuario, clave y nombre de base leídos del `.env` de la raíz, con valores por
  defecto razonables para desarrollo.
- Volumen con nombre para que los datos sobrevivan a `docker compose down`.
- `healthcheck` con `pg_isready`, para que el `setup.sh` pueda esperar a que la
  base esté lista de verdad y no solo "arrancando".
- Monta `./db/init/` en `/docker-entrypoint-initdb.d/`, así el SQL que esté ahí
  se aplica solo la primera vez que se crea el volumen.

**`./db/init/` tiene que existir siempre**, aunque quede vacía: si se borra la
carpeta, `docker compose up` falla. Déjale un `.gitkeep`.

Agrega también al `.env.example` las variables nuevas, y actualiza `DATABASE_URL`
para que apunte a esta base.

**Esto es una herramienta nueva**, así que hay que dejarla en un ADR
(`docs/adr/0003-docker-compose-postgres.md`) en estado `propuesta`, igual que el
ADR 0002. `AGENTS.md` exige aprobar herramientas nuevas el miércoles.

---

## 6. Trabajo 2 — `/api/salud` que verifique la base

Este endpoint es **el "hola mundo" de la plantilla**: si responde bien, es
porque toda la tubería está armada. Y no tiene nada de dominio, así que se queda
para siempre.

```
GET /api/salud
```

Respuesta cuando todo está bien:

```json
{ "estado": "ok", "bd": "ok", "version": "1.0.0" }
```

Cuando la base no responde: **503**, con `"bd": "sin conexion"` y un mensaje
útil. No una traza de Python.

La comprobación de la base tiene que ser barata: un `SELECT 1`, nada más.

La conexión vive en `backend/app/db.py`, que lee `DATABASE_URL` del `.env` y es
**el único archivo que sabe cómo conectarse**. Nadie más toca eso. Ese archivo
sí es plantilla y se queda.

---

## 7. Trabajo 3 — `setup.sh` en la raíz

Un solo script que orqueste lo que ya existe. Que **no duplique** lo que hacen
`backend/setup.sh` y `frontend/setup.sh`: que los llame.

Pasos, en orden:

1. Verificar Docker instalado y corriendo. Si no, mensaje claro en español con
   el enlace de descarga, y salir con código distinto de cero.
2. Crear el `.env` desde `.env.example` si no existe.
3. `docker compose up -d` y **esperar al healthcheck**, con un tope de tiempo y
   un mensaje de progreso. Nunca esperar en silencio.
4. Llamar a `backend/setup.sh`.
5. Llamar a `frontend/setup.sh`.
6. Verificar que el backend arranca y que `/api/salud` responde `bd: ok`.
7. Imprimir los dos comandos para levantar el proyecto.

Reglas para el script:

- **Idempotente.** Correrlo dos veces no rompe nada.
- **Nunca se cuelga en silencio.** Si algo va a tardar, lo anuncia antes.
- **Falla con mensaje en español** y código distinto de cero. Jamás se queda
  esperando una respuesta del teclado.
- **Sin tildes en los mensajes de consola**, para evitar problemas de
  codificación en terminales de Windows.

---

## 8. Trabajo 4 — Cercar y convertir el ejemplo

El ejemplo actual usa `productos` con `{id, nombre, stock}`. Es demasiado
genérico: un estudiante puede confundirlo con su propio dominio y construir
encima en vez de borrarlo.

Hay que hacer dos cosas: **moverlo a carpetas `ejemplo/`** y **cambiarlo a un
dominio inconfundiblemente ajeno**.

### 8.1 Dónde queda todo

```
frontend/src/ejemplo/        <- cliente API + pantalla + formulario
backend/app/ejemplo/         <- router y consultas SQL
db/init/01-ejemplo.sql       <- tabla y datos de prueba
docs/ejemplo-contrato.md     <- el contrato del ejemplo
```

Y en el `README` de la raíz, esta línea exacta:

```bash
# Cuando definan su dominio, borren el ejemplo completo:
git rm -r frontend/src/ejemplo backend/app/ejemplo docs/ejemplo-contrato.md
git rm db/init/01-ejemplo.sql
```

Después de correr eso, **el proyecto tiene que seguir compilando, `/api/salud`
tiene que seguir respondiendo, y `setup.sh` tiene que seguir funcionando.**
Eso es criterio de aceptación, no una sugerencia: pruébalo de verdad.

### 8.2 El dominio del ejemplo: inventario de calzado

Es de uno de los tres proyectos del semillero (industria de calzado y textil:
inventarios, producción y logística). Se eligió a propósito un dominio real y
específico, porque así **nadie lo confunde con el suyo**.

Una sola tabla, `variantes`:

| Campo | Tipo | Notas |
|---|---|---|
| `id` | serial | PK |
| `referencia` | varchar(120) | el modelo, ej: "Bota chelsea cuero" |
| `talla` | integer | |
| `color` | varchar(40) | |
| `stock` | integer | por defecto 0 |
| `creado_en` | timestamp | por defecto `now()` |

**La lección que enseña esta tabla, y por eso se eligió así:** en calzado el
stock **no vive en la referencia, vive en la variante**. Una misma bota en talla
38 negra y en talla 40 café son dos inventarios distintos. Modelarlo mal es el
error clásico del sector y obliga a rehacer media base de datos después.

Con una sola tabla plana se ve solo: varias filas comparten `referencia` y cada
una tiene su propio `stock`. No hace falta un JOIN para enseñarlo.

Datos de prueba, que se vean reales:

```
Bota chelsea cuero   | 38 | negro  | 12
Bota chelsea cuero   | 40 | cafe   |  5
Tenis lona urbano    | 39 | blanco | 30
Tenis lona urbano    | 41 | blanco |  0
Sandalia cuero trenzado | 37 | miel |  8
```

### 8.3 Los endpoints del ejemplo

Van bajo un prefijo que los delata:

| Endpoint | Qué hace | Respuesta |
|---|---|---|
| `GET /api/ejemplo/variantes` | Lista las variantes | 200, lista de `{id, referencia, talla, color, stock}` |
| `POST /api/ejemplo/variantes` | Crea una variante | 201, la variante creada con su `id` |

Tabla de errores, que el frontend ya tiene copiada y hay que mantener:

| Código | Cuándo |
|---|---|
| 400 | Datos inválidos |
| 404 | No existe el recurso |
| 500 | Error del servidor |

**Cuidado con esto:** FastAPI devuelve **422** por defecto cuando Pydantic
rechaza datos, pero el contrato dice **400** y el frontend tiene esa tabla
copiada literal. Hay que mapearlo, o un dato inválido va a mostrar un mensaje
vacío en pantalla. Es el error más probable de toda la tarea.

### 8.4 Qué NO hacer en el ejemplo

- **No inventar reglas de negocio.** El formulario valida solo lo de formulario
  (`required`, `type="number"`), que evita un `NaN`. Nada de "el stock tiene que
  ser entero positivo" ni "la talla va entre 34 y 46": eso no está escrito en
  ningún documento y no es tuyo decidirlo.
- **No agregar una segunda tabla ni relaciones.** Una tabla basta para enseñar
  el patrón. El equipo que quiera relaciones las modelará con su empresa.
- **No agregar más endpoints** que los dos del contrato.
- Conservar la constante `USAR_DATOS_FALSOS`, que ya existe y arranca en `true`,
  con su banda de aviso en pantalla. Ahora que hay base de datos real, el
  ejemplo debe funcionar bien en `true` **y** en `false`.

### 8.5 Qué pasa con los documentos de la plantilla

`docs/03-api.md` y `docs/04-datos.md` vuelven a ser **plantillas con
placeholders vacíos**, como estaban antes. El contenido del ejemplo se va a
`docs/ejemplo-contrato.md`, que se borra junto con el resto.

`frontend/README.md` debe explicar la regla: **el ejemplo es de dónde se copia
el patrón, no de dónde se construye encima.**

---

## 9. Trampas conocidas — no las redescubras

1. **Un solo `.env`, y vive en la raíz.** `backend/setup.sh` copia
   `../.env.example` a `../.env`. El frontend lo lee con `envDir` apuntando a la
   raíz. No crear un segundo `.env` dentro de `backend/` ni de `frontend/`.

2. **`setup.sh` dice literalmente ".env ya existe, no lo toco".** Si agregas
   variables nuevas, quien ya tenía `.env` **no las va a recibir** y le va a
   fallar sin explicación. Ponles un valor por defecto razonable en el código y
   avísalo en la descripción del PR.

3. **Solo las variables `VITE_` llegan al navegador.** Verificado: un
   `DATABASE_URL` en el `.env` de la raíz no aparece en `dist/`. Por eso el
   `.env` único es seguro.

4. **TypeScript 6 rompe el build con `baseUrl`.** Ya está quitado. No lo vuelvas
   a agregar aunque la documentación de shadcn lo pida.

5. **`oxlint` tiene `no-console: warn`.** Es intencional, hace cumplir
   `AGENTS.md` automáticamente.

6. **CORS ya está resuelto.** Si sale un error de CORS, revisa `CORS_ORIGINS` en
   el `.env`, no toques `main.py`.

7. **Los placeholders del README ("NOMBRE DEL PROYECTO") y el título
   "Semillero SINDES" son a propósito.** Es una plantilla. No los rellenes.

8. **El `.gitignore` ya cubre `.env`, `node_modules/` y `.venv/`.** Agrégale el
   volumen de Docker si queda en el árbol del proyecto.

---

## 10. Criterios de aceptación

Pruébalos de verdad, no los supongas.

1. En un **clon limpio** en un directorio temporal, `bash setup.sh` termina bien
   sin pedir nada por teclado.
2. Después, `uvicorn` y `npm run dev` levantan y la página carga con datos
   reales de la base.
3. `GET /api/salud` devuelve `bd: ok` con la base arriba.
4. Con la base apagada (`docker compose stop`), `/api/salud` devuelve **503** con
   mensaje claro, y la pantalla del ejemplo muestra el mensaje de la tabla de
   errores, no una traza de Python.
5. El ejemplo funciona con `USAR_DATOS_FALSOS` en `true` y en `false`.
6. Datos inválidos en el POST devuelven **400**, no 422.
7. **Después de borrar el ejemplo** con el comando del README: el backend
   arranca, `/api/salud` responde, `npm run build` y `npm run lint` pasan, y
   `setup.sh` vuelve a correr de cero sin errores.
8. Correr `setup.sh` dos veces seguidas no rompe nada.
9. `docker compose down && docker compose up -d` conserva los datos.

---

## 11. Qué NO debes hacer

- **No implementar dominio fuera de `ejemplo/`.** Si escribes lógica de negocio
  en `backend/app/routers/` o en `frontend/src/components/`, te saliste del
  alcance.
- **No agregar ningún ORM**, ni ninguna librería nueva sin dejar un ADR en
  estado `propuesta`.
- No containerizar el backend ni el frontend. Solo Postgres va en Docker.
- No inventar reglas de negocio ni validaciones que nadie escribió.
- No escribir credenciales, hosts ni puertos en el código.
- No hacer commit directo a `main`.
- No mezclar los cuatro trabajos en un solo PR. Son cuatro commits separados
  como mínimo, y se pueden partir en dos PRs: infraestructura (1, 2, 3) y
  ejemplo (4).

---

## 12. Pendiente del semillero que te condiciona

El semillero va a recibir un servidor en la nube llamado "Kyra", pero **todavía
no se conocen sus condiciones** (acceso, sistema operativo, recursos, si tiene
IP pública, hasta cuándo está garantizado). Hay un issue abierto.

No bloquea nada de esta tarea, con una condición: **todo lo que dependa del
entorno sale del `.env`.** Cuando llegue el servidor, mudarse debe costar
cambiar `DATABASE_URL` y `CORS_ORIGINS`, y nada más.

Por eso el `docker-compose.yml` debe leer sus credenciales del `.env` en vez de
tenerlas quemadas: el día que la base viva en el servidor, se apaga el
contenedor y se cambia una línea.