# ADR 0002 — Tailwind CSS y shadcn/ui en el frontend

Fecha:
Estado: aceptada

## Contexto

Hay que decidir con que se escriben los estilos del frontend y de donde salen los
componentes de interfaz (botones, tarjetas, formularios, tablas). Sin esa decision,
cada integrante lo resuelve a su manera y las pantallas no se parecen entre si.

## Opciones

- **A. CSS plano.** Cero dependencias. Cada quien escribe sus estilos a mano.
- **B. Tailwind CSS.** Clases utilitarias en el JSX. Una dependencia.
- **C. Tailwind + shadcn/ui + lucide-react.** Ademas de Tailwind, componentes ya
  construidos que se **copian dentro del repo** (no se importan de una libreria)
  y un set de iconos.

## Decision

Escogimos C: Tailwind CSS v4, shadcn/ui (estilo `radix-nova`) y lucide-react.

La plantilla trae shadcn configurado pero **sin componentes agregados**. Cada equipo
agrega los que necesite con `npx shadcn@latest add <componente>`, y quedan en
`frontend/src/components/ui/`.

## Por que

- Con CSS plano se va mucho tiempo peleando con estilos en vez de con el problema
  del proyecto, y las pantallas quedan disparejas.
- shadcn/ui **no es una libreria de la que se dependa**: el codigo de cada componente
  se copia a `src/components/ui/` y queda en el repo. Se puede leer, editar y explicar.
- Los componentes ya vienen accesibles (foco con teclado, lectores de pantalla).

## Que perdemos

- Hay que aprender Tailwind. Las clases en el JSX se ven cargadas al principio.
- Mas dependencias que mantener: `tailwindcss`, `@tailwindcss/vite`, `shadcn`,
  `radix-ui`, `class-variance-authority`, `cn`, `tw-animate-css`,
  `@fontsource-variable/geist` y `lucide-react`.
- Los componentes de `src/components/ui/` los genera la herramienta. Regla: si vas
  a tocar uno, primero entiendelo; si no lo entiendes, envuelvelo en un componente propio.
