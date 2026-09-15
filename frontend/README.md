# Frontend

React + Vite + TypeScript, con Tailwind CSS v4, shadcn/ui y lucide-react.

## Instalacion

Lo normal es instalar el proyecto entero desde la raiz, con un solo comando:

```bash
bash setup.sh
```

Si solo necesitas el frontend, desde esta carpeta:

```bash
bash setup.sh
```

Ese script revisa que tengas **Node 20 o mas nuevo**, instala las dependencias
exactas de `package-lock.json`, crea el `.env` de la raiz si no existe y compila
una vez para comprobar que todo quedo bien.

`node_modules/` no se sube al repo: se regenera con el script.

## Comandos

| Comando | Que hace |
|---|---|
| `npm run dev` | levanta la interfaz en http://localhost:5173 |
| `npm run build` | revisa los tipos y compila para produccion |
| `npm run lint` | revisa el codigo con oxlint |
| `npm run preview` | sirve la version compilada |

## Estructura

```
frontend/
├── index.html           punto de entrada de la pagina
├── setup.sh             instala todo lo necesario
├── package.json         dependencias y comandos
├── vite.config.ts       configuracion de Vite (alias @, .env de la raiz)
├── components.json      configuracion de shadcn/ui
├── public/              archivos estaticos (favicon, imagenes)
└── src/
    ├── main.tsx         arranca React
    ├── App.tsx          componente raiz
    ├── index.css        Tailwind y el tema de shadcn
    ├── components/      componentes propios, reutilizables
    │   └── ui/          componentes de shadcn (se agregan con el CLI)
    ├── pages/           una pantalla por archivo
    ├── services/        lo unico que habla con el backend
    ├── hooks/           hooks propios de React
    └── lib/             utilidades (utils.ts viene de shadcn)
```

| Carpeta | Que va | Se edita a mano |
|---|---|---|
| `src/components/ui/` | componentes de shadcn | No. Se agregan con el CLI |
| `src/components/` | componentes propios | Si |
| `src/pages/` | pantallas completas | Si |
| `src/services/` | llamadas al backend, una funcion por endpoint | Si |
| `src/hooks/` | hooks propios | Si |
| `src/lib/utils.ts`, `src/index.css` | lo que genero shadcn | Solo si sabes lo que haces |

## Agregar componentes de shadcn

```bash
npx shadcn@latest add button card input
```

Quedan en `src/components/ui/`. Catalogo: https://ui.shadcn.com/docs/components

Iconos: https://lucide.dev/icons

## Imports con @

`@/` apunta a `src/`, asi no hay que contar `../../`:

```ts
import { Button } from "@/components/ui/button"
```

## Variables de entorno

El frontend lee el `.env` de la **raiz del repo**, no uno propio. Hay uno solo
para todo el proyecto.

| Variable | Para que |
|---|---|
| `VITE_API_URL` | direccion base del backend, ej: `http://localhost:8000/api` |

Se usa asi:

```ts
const API_URL = import.meta.env.VITE_API_URL
```

Vite solo expone al navegador las variables que empiezan por `VITE_`, y todo lo
que lleve ese prefijo lo puede ver cualquiera que abra la pagina: **ahi nunca van
claves ni contraseñas**.

## Llamar al backend

Todo lo que hable con el backend va en `src/services/`, con **una funcion
exportada por cada endpoint** de `docs/03-api.md`. Asi el archivo se puede leer
al lado del contrato para comprobar que no se invento nada.

Dos cosas de `fetch` que conviene saber:

- Solo lanza error cuando la peticion **no llego** (backend apagado, sin red,
  CORS). Con un 400, 404 o 500 no lanza nada: hay que revisar `response.ok`.
- Los codigos de error que devuelve el backend son los de la tabla "Errores"
  de `docs/03-api.md`.

## Un detalle que confunde

En desarrollo cada peticion se ve **dos veces** en la pestaña Network. Es
`<StrictMode>` de `src/main.tsx`, que monta todo dos veces a proposito para
destapar errores. En produccion pasa una sola vez.
