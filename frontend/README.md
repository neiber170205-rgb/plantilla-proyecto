# Frontend

React + Vite + TypeScript. Tailwind v4 y shadcn/ui para los estilos.

```bash
npm run dev      # http://localhost:5173
npm run lint     # oxlint
npm run build    # revisa tipos y compila
```

La instalacion la hace `bash ../setup.sh` desde la raiz, que instala todo el
proyecto. Si solo quieres el frontend: `bash setup.sh`.

## Que se toca y que no

| Carpeta o archivo | Que hay | Se toca |
|---|---|---|
| `src/components/ui/` | componentes de shadcn | No. Se agregan con `npx shadcn@latest add` |
| `src/lib/utils.ts`, `src/index.css` | lo que genero shadcn | No |
| `src/ejemplo/` | el ejemplo borrable | **Se copia, no se edita** (ver abajo) |
| `src/App.tsx` | el encabezado y que pantalla se muestra | Si |
| `index.html` | el titulo de la pestaña | Si |

## El ejemplo es de donde se copia el patron, no donde se construye encima

`src/ejemplo/` trae un caso completo y funcionando —inventario de calzado— para
que veas el patron entero: el archivo que habla con la api, el formulario y la
pantalla con sus tres estados.

**No escribas tu dominio ahi dentro.** Copia la carpeta con el nombre de tu
dominio, adaptala, y borra `src/ejemplo/`:

```bash
cp -r src/ejemplo src/pedidos     # y adentro: renombra tipos y funciones
```

Cuando ya no lo necesites, el comando de borrado esta en el README de la raiz.
Despues de borrarlo `npm run build` sigue pasando y no hay que tocar `App.tsx`:
usa `import.meta.glob`, que se resuelve al compilar y queda vacio si la carpeta
no esta. En su lugar aparece un recuadro que dice donde va tu primera pantalla.

## Los tres archivos del ejemplo

| Archivo | Que hace |
|---|---|
| `src/ejemplo/api.ts` | lo unico que habla con el backend |
| `src/ejemplo/index.tsx` | la pantalla: estado, carga, error, tabla |
| `src/ejemplo/VarianteForm.tsx` | el formulario |

## La regla del contrato

`api.ts` tiene **una funcion exportada por endpoint** del contrato:

| Endpoint | Funcion |
|---|---|
| `GET /ejemplo/variantes` | `getVariantes()` |
| `POST /ejemplo/variantes` | `postVariante(nueva)` |

El verbo va en ingles y el dominio en español, como dice `../AGENTS.md`.

Si necesitas un endpoint que no esta en el contrato, **no lo agregues aqui**.

### Cuando cambia el contrato

En este orden, nunca al reves:

1. Se propone en el canal y se aprueba en la reunion del miercoles.
2. Se actualiza `../docs/03-api.md`.
3. Se cambia el backend.
4. Se cambian los tipos y las funciones del archivo de api.
5. Se actualizan los datos falsos de ese mismo archivo.
6. Se cambia la pantalla.

## Datos falsos

Arriba de `src/ejemplo/api.ts` hay una linea:

```ts
export const USAR_DATOS_FALSOS = true
```

En `true` la pantalla funciona sin backend, y arriba sale un aviso para que nadie
crea que ya esta conectado. Cuando el backend responda, se pone en `false`.

Se cambia a mano y a proposito: asi queda visible en el pull request y todo el
equipo sabe contra que esta corriendo la demo.

## La URL del backend

Sale de `VITE_API_URL`, que vive en el `.env` de la raiz del repo (mira
`../.env.example`). Es UN SOLO `.env` para backend y frontend, y por eso
`vite.config.ts` lleva un `envDir` que apunta a la carpeta de arriba.
Si la variable no existe, se usa `http://localhost:8000/api`.

Vite solo le entrega al navegador las variables que empiezan por `VITE_`, y todo
lo que lleve ese prefijo queda visible para cualquiera que abra la pagina: ahi
nunca van claves ni contraseñas. El `.env` real NUNCA se sube.

## Errores

`api.ts` traduce a español lo que puede fallar:

| Que paso | Que ve el usuario |
|---|---|
| 400 / 404 / 500 | los mensajes de la tabla "Errores" del contrato |
| la peticion no llego (backend apagado, sin red, CORS) | `No se pudo conectar con <URL>. Revisa que el backend este corriendo.` |

La pantalla solo los muestra, con un boton **Reintentar** al lado.

## Validaciones

El formulario solo tiene `required` y `type="number"`. Eso es validacion de
formulario: lo minimo para que `Number()` no llegue como `NaN` al JSON.

**Reglas de negocio no hay ninguna**, porque todavia no estan escritas. Se
escriben primero en `../docs/01-requisitos.md` (RN-01, RN-02...) y despues se
programan. Si crees que falta una, se pregunta en el canal; no se inventa aqui.

## Un detalle que confunde

En desarrollo vas a ver DOS peticiones en la pestaña Network. Es `<StrictMode>`
de `src/main.tsx`, que monta todo dos veces a proposito para destapar errores.
En produccion pasa una sola vez.
