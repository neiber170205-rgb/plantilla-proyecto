#!/usr/bin/env bash
# ---------------------------------------------------------------
# Semillero SINDES - FESC
# Instala todo lo que el frontend necesita para correr.
#
# Se corre asi, una vez por maquina, despues de clonar el repo:
#   cd frontend
#   bash setup.sh
#
# Cada integrante lo corre en su computador, porque node_modules
# no se sube al repo (pesa cientos de megas y se regenera solo).
# ---------------------------------------------------------------
set -euo pipefail

# Correr siempre parado en la carpeta del script, sin importar
# desde donde lo hayan invocado.
cd "$(dirname "$0")"

echo ""
echo "=== Frontend del semillero SINDES ==="
echo ""

# --- 1. Revisar Node -------------------------------------------
if ! command -v node >/dev/null 2>&1; then
  echo "ERROR: no tienes Node instalado."
  echo "Descargalo de https://nodejs.org (version LTS) y vuelve a correr esto."
  exit 1
fi

NODE_MAJOR="$(node -v | sed 's/v\([0-9]*\).*/\1/')"
if [ "$NODE_MAJOR" -lt 20 ]; then
  echo "ERROR: tienes Node $(node -v). Vite necesita Node 20 o mas nuevo."
  echo "Actualiza desde https://nodejs.org (version LTS)."
  exit 1
fi
echo "Node $(node -v) — ok"

# --- 2. Dependencias -------------------------------------------
# 'npm ci' instala EXACTAMENTE las versiones de package-lock.json,
# asi a todos les queda lo mismo. Si el lock quedo desactualizado
# (porque alguien agrego una libreria y no lo commiteo), npm ci falla;
# ahi caemos a 'npm install', que lo arregla.
echo ""
echo ">> Instalando dependencias..."
if [ -f package-lock.json ]; then
  npm ci || {
    echo ""
    echo "   npm ci fallo (package-lock.json desactualizado). Uso npm install."
    npm install
  }
else
  npm install
fi

# --- 3. Archivo .env -------------------------------------------
# Es uno solo para todo el proyecto y vive en la raiz del repo.
if [ -f ../.env ]; then
  echo ""
  echo ".env ya existe, no lo toco."
elif [ -f ../.env.example ]; then
  cp ../.env.example ../.env
  echo ""
  echo ">> Cree el archivo .env en la raiz, a partir de .env.example."
  echo "   Revisa que VITE_API_URL apunte a donde tengas corriendo el backend."
fi

# --- 4. Verificar que de verdad quedo -------------------------
# Si el build pasa, es que las dependencias, TypeScript, Tailwind
# y shadcn quedaron bien. Vale los segundos que tarda.
echo ""
echo ">> Verificando la instalacion (compilando una vez)..."
npm run build >/dev/null
rm -rf dist
echo "   compila — ok"

# --- 5. Listo --------------------------------------------------
echo ""
echo "=== Frontend listo ==="
echo ""
echo "Arrancalo con:"
echo "     npm run dev"
echo ""
echo "Y abre http://localhost:5173"
echo ""
echo "El backend va aparte, en otra terminal (ver backend/setup.sh)."
