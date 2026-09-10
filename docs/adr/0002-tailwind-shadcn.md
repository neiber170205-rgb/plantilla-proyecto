# ADR 0002 — Tailwind CSS y shadcn/ui en el frontend

Fecha: 2026-09-10
Estado: propuesta

## Contexto

AGENTS.md fija el stack del frontend en "React + Vite" y dice que no se agregan
librerias sin aprobarlo en la reunion del miercoles.

Al montar la base del frontend habia que decidir con que se escriben los estilos y
de donde salen los componentes de interfaz (botones, tarjetas, formularios, tablas).
Sin esa decision, cada integrante iba a resolverlo a su manera y las pantallas del
proyecto no se iban a parecer entre si.

Esta ADR queda como **propuesta** hasta que se apruebe en la reunion. Si no se aprueba,
se revierte: se quitan las dependencias y se reescriben los estilos con CSS plano.

## Opciones

- **A. CSS plano.** Cero dependencias. Cada quien escribe sus estilos a mano.
- **B. Tailwind CSS.** Clases utilitarias en el JSX. Una dependencia.
- **C. Tailwind + shadcn/ui + lucide-react.** Ademas de Tailwind, componentes ya
  construidos que se **copian dentro del repo** (no se importan de una libreria)
  mas un set de iconos.

## Decision

Escogimos C: Tailwind CSS v4, shadcn/ui (estilo `radix-nova`) y lucide-react.

Quedan instalados los componentes base: `button`, `card`, `input`, `label` y `table`,
en `frontend/src/components/ui/`.

## Por que

- Con CSS plano el equipo se iba a ir semanas peleando con estilos en vez de
  con el problema del proyecto, y las pantallas iban a quedar disparejas.
- shadcn/ui **no es una libreria de la que dependamos**: el codigo de cada componente
  se copia a `src/components/ui/` y queda nuestro. Se puede leer, editar y explicar
  en la demo del miercoles, que es justo lo que pide AGENTS.md.
- Los componentes ya vienen accesibles (foco con teclado, lectores de pantalla),
  que es algo que a mano no lo ibamos a hacer bien.

## Que perdemos

- Hay que aprender Tailwind. Las clases en el JSX se ven cargadas al principio.
- El `package.json` crece: `tailwindcss`, `@tailwindcss/vite`, `shadcn`, `radix-ui`,
  `class-variance-authority`, `cn`, `tw-animate-css`, `@fontsource-variable/geist`
  y `lucide-react`. Son mas piezas que mantener y actualizar.
- Los componentes de `src/components/ui/` los genero la herramienta, no nosotros.
  Regla del equipo: **si vas a tocar uno, primero entiendelo**; y si no lo entiendes,
  no lo modifiques, envuelvelo en un componente propio.
