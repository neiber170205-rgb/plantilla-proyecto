# Frontend

React + Vite + TypeScript. Tailwind v4 y shadcn/ui para los estilos.

```bash
npm install      # o: bash setup.sh, la primera vez
npm run dev      # http://localhost:5173
npm run lint     # oxlint
npm run build    # revisa tipos y compila
```

## Que se toca y que no

| Carpeta o archivo | Que hay | Se toca |
|---|---|---|
| `src/components/ui/` | componentes de shadcn | No. Se agregan con `npx shadcn@latest add` |
| `src/lib/utils.ts`, `src/index.css` | lo que genero shadcn | No |
| `src/api/productos.ts` | lo unico que habla con el backend | Si, es el molde |
| `src/components/Productos.tsx` | la pantalla de ejemplo | Si, es el molde |
| `src/components/ProductoForm.tsx` | el formulario de esa pantalla | Si, es el molde |
| `src/App.tsx` | el encabezado y que pantalla se muestra | Si |
| `index.html` | el titulo de la pestaña | Si |

Son cuatro archivos de codigo propio. Leelos en ese orden y ya sabes como funciona todo.

## La regla del contrato

`src/api/productos.ts` tiene **una funcion exportada por endpoint** de `../docs/03-api.md`:

| Endpoint del contrato | Funcion |
|---|---|
| `GET /productos` | `getProductos()` |
| `POST /productos` | `postProducto(nuevo)` |

El verbo va en ingles y el dominio en español, como dice `../AGENTS.md`.

Si necesitas un endpoint que no esta en ese documento, **no lo agregues aqui**.

### Cuando cambia el contrato

En este orden, nunca al reves:

1. Se propone en el canal y se aprueba en la reunion del miercoles.
2. Se actualiza `../docs/03-api.md`.
3. Se cambian los tipos y las funciones de `src/api/productos.ts`.
4. Se actualizan los datos falsos de ese mismo archivo.
5. Se cambia la pantalla.

## Datos falsos

Arriba de `src/api/productos.ts` hay una linea:

```ts
export const USAR_DATOS_FALSOS = true
```

En `true` la pantalla funciona sin backend, con los dos productos de mentira que
estan en ese mismo archivo, y arriba sale un aviso para que nadie crea que ya
esta conectado. Cuando el backend responda `/productos`, se pone en `false`.

Se cambia a mano y a proposito: asi queda visible en el pull request y todo el
equipo sabe contra que esta corriendo la demo.

## La URL del backend

Sale de `VITE_API_URL`, que vive en el `.env` de la raiz del repo (mira
`../.env.example`). Es UN SOLO `.env` para backend y frontend, y por eso
`vite.config.ts` lleva un `envDir` que apunta a la carpeta de arriba: para leer
ese archivo y no uno aparte.
Si la variable no existe, se usa `http://localhost:8000/api`, que es la base
que declara el contrato.

Vite solo le entrega al navegador las variables que empiezan por `VITE_`, y todo
lo que lleve ese prefijo queda visible para cualquiera que abra la pagina: ahi
nunca van claves ni contraseñas. El `.env` real NUNCA se sube.

## Errores

`src/api/productos.ts` traduce a español lo que puede fallar:

| Que paso | Que ve el usuario |
|---|---|
| 400 / 404 / 500 | los mensajes de la tabla "Errores" de `../docs/03-api.md` |
| la peticion no llego (backend apagado, sin red, CORS) | `No se pudo conectar con <URL>. Revisa que el backend este corriendo.` |

La pantalla solo los muestra, con un boton **Reintentar** al lado.

## Validaciones

El formulario solo tiene `required` y `type="number"`. Eso es validacion de
formulario: lo minimo para que `Number(stock)` no llegue como `NaN` al JSON.

**Reglas de negocio no hay ninguna**, porque todavia no estan escritas. Se
escriben primero en `../docs/01-requisitos.md` (RN-01, RN-02...) y despues se
programan. Si crees que falta una, se pregunta en el canal; no se inventa aqui.

## Como copiar el patron para tu dominio

Tu proyecto seguramente no vende productos. Cuando sepas cual es tu entidad real
(pedidos, prestamos, asistencias):

1. Escribe sus endpoints en `../docs/03-api.md`.
2. Copia `src/api/productos.ts` a `src/api/pedidos.ts` y cambia tipos y funciones.
3. Copia `src/components/Productos.tsx` y `ProductoForm.tsx` a `Pedidos.tsx` y `PedidoForm.tsx`.
4. Cambia `<Productos />` por `<Pedidos />` en `src/App.tsx`.

Los archivos de productos se borran cuando ya no los necesites.

## Un detalle que confunde

En desarrollo vas a ver DOS peticiones `GET /productos` en la pestaña Network.
Es `<StrictMode>` de `src/main.tsx`, que monta todo dos veces a proposito para
destapar errores. En produccion pasa una sola vez.
