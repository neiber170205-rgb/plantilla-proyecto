#!/usr/bin/env bash
# ---------------------------------------------------------------
# Instala el backend: entorno virtual + FastAPI + dependencias
#
# Se corre desde la carpeta backend/:
#   cd backend
#   bash setup.sh
#
# A diferencia del frontend, este SI lo corre cada integrante
# en su maquina, porque el entorno virtual no se sube al repo.
# ---------------------------------------------------------------
set -euo pipefail

# Correr siempre parado en la carpeta del script, sin importar desde donde
# lo hayan invocado. El setup.sh de la raiz lo llama como 'bash backend/setup.sh'.
cd "$(dirname "$0")"

echo ""
echo "=== Instalacion del backend ==="
echo ""

# --- 1. Encontrar Python ---------------------------------------
if command -v python3 >/dev/null 2>&1; then
  PY=python3
elif command -v python >/dev/null 2>&1; then
  PY=python
else
  echo "ERROR: no tienes Python instalado."
  echo "Descargalo de https://www.python.org/downloads/"
  echo "En Windows, marca la casilla 'Add Python to PATH' al instalarlo."
  exit 1
fi

PY_VER="$($PY -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')"
PY_OK="$($PY -c 'import sys; print(1 if sys.version_info >= (3, 10) else 0)')"
if [ "$PY_OK" != "1" ]; then
  echo "ERROR: tienes Python $PY_VER. Se necesita 3.10 o mas nuevo."
  exit 1
fi
echo "Python $PY_VER — ok"

# --- 2. Entorno virtual ----------------------------------------
if [ -d .venv ]; then
  echo ".venv ya existe, lo reutilizo."
else
  echo ""
  echo ">> Creando entorno virtual en .venv ..."
  $PY -m venv .venv
fi

# Los ejecutables del venv estan en bin/ (Linux, Mac)
# o en Scripts/ (Windows con Git Bash).
if [ -f .venv/bin/python ]; then
  VENV_PY=.venv/bin/python
elif [ -f .venv/Scripts/python.exe ]; then
  VENV_PY=.venv/Scripts/python.exe
else
  echo "ERROR: el entorno virtual quedo mal creado. Borra .venv y reintenta."
  exit 1
fi

# --- 3. Dependencias -------------------------------------------
echo ""
echo ">> Actualizando pip..."
"$VENV_PY" -m pip install --quiet --upgrade pip

echo ">> Instalando dependencias de requirements.txt..."
"$VENV_PY" -m pip install --quiet -r requirements.txt

# --- 4. Archivo .env -------------------------------------------
if [ -f ../.env ]; then
  echo ""
  echo ".env ya existe, no lo toco."
elif [ -f ../.env.example ]; then
  cp ../.env.example ../.env
  echo ""
  echo ">> Cree el archivo .env a partir de .env.example."
  echo "   ABRELO Y LLENA LOS VALORES REALES antes de arrancar."
fi

# --- 5. Verificar que arranca ----------------------------------
echo ""
echo ">> Verificando la instalacion..."
"$VENV_PY" -c "import fastapi, uvicorn; print('FastAPI', fastapi.__version__, '— ok')"

# --- 6. Listo --------------------------------------------------
echo ""
echo "=== Backend listo ==="
echo ""
echo "1) Activa el entorno virtual:"
if [ -f .venv/bin/python ]; then
  echo "     source .venv/bin/activate"
else
  echo "     source .venv/Scripts/activate      # Git Bash"
  echo "     .venv\\Scripts\\activate            # PowerShell / CMD"
fi
echo ""
echo "2) Arranca la API:"
echo "     uvicorn app.main:app --reload"
echo ""
echo "3) Abre la documentacion automatica:"
echo "     http://localhost:8000/docs"
echo ""
echo "Cuando agregues una libreria nueva, actualiza requirements.txt con:"
echo "     pip freeze > requirements.txt"
echo ""
echo "El .venv NO se sube al repo (ya esta en .gitignore)."
