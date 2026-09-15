#!/usr/bin/env bash
# ---------------------------------------------------------------
# Deja el proyecto entero listo para trabajar, con un solo comando.
#
#   bash setup.sh
#
# Hace, en orden:
#   1. revisa que Docker este instalado y prendido
#   2. crea el .env si no existe
#   3. levanta PostgreSQL y espera a que responda de verdad
#   4. instala el backend  (llama a backend/setup.sh)
#   5. instala el frontend (llama a frontend/setup.sh)
#   6. comprueba que el backend se conecta a la base
#
# Correrlo dos veces no rompe nada.
# ---------------------------------------------------------------
set -euo pipefail

cd "$(dirname "$0")"

echo ""
echo "==================================================="
echo "  Instalacion completa del proyecto"
echo "==================================================="

# --- 1. Docker --------------------------------------------------
echo ""
echo "[1/6] Revisando Docker..."

if ! command -v docker >/dev/null 2>&1; then
  echo ""
  echo "ERROR: no tienes Docker instalado."
  echo "Descargalo de https://docs.docker.com/get-docker/"
  echo "En Windows y Mac se llama Docker Desktop."
  exit 1
fi

if ! docker info >/dev/null 2>&1; then
  echo ""
  echo "ERROR: Docker esta instalado pero no esta corriendo."
  echo "Abre Docker Desktop y espera a que diga 'Engine running'."
  echo "En Linux:  sudo systemctl start docker"
  exit 1
fi
echo "      Docker ok"

# --- 2. Archivo .env --------------------------------------------
echo ""
echo "[2/6] Revisando el .env..."

if [ -f .env ]; then
  echo "      .env ya existe, no lo toco."
  echo "      OJO: si el equipo agrego variables nuevas, comparalo con .env.example"
else
  cp .env.example .env
  echo "      Cree el .env a partir de .env.example."
fi

# --- 3. Base de datos -------------------------------------------
echo ""
echo "[3/6] Levantando PostgreSQL en Docker..."
echo "      (la primera vez se descarga la imagen, puede tardar unos minutos)"

if ! docker compose up -d; then
  echo ""
  echo "ERROR: no se pudo levantar la base."
  echo ""
  echo "Si arriba dice 'port is already allocated', ya tienes algo usando el"
  echo "puerto 5432 (otro Postgres, u otro proyecto con Docker). Arreglalo asi:"
  echo ""
  echo "  1. abre el archivo .env de esta carpeta"
  echo "  2. cambia    POSTGRES_PORT=5432    por    POSTGRES_PORT=5433"
  echo "  3. en la linea DATABASE_URL cambia :5432/ por :5433/"
  echo "  4. vuelve a correr:  bash setup.sh"
  echo ""
  echo "Si dice otra cosa, mira el detalle con:  docker compose logs db"
  exit 1
fi

echo ""
echo "      Esperando a que la base acepte conexiones..."

CONTENEDOR="$(docker compose ps -q db)"
if [ -z "$CONTENEDOR" ]; then
  echo ""
  echo "ERROR: el contenedor de la base no arranco."
  echo "Mira que paso con:  docker compose logs db"
  exit 1
fi

INTENTO=0
LIMITE=60   # 60 x 2s = hasta 2 minutos
while [ "$INTENTO" -lt "$LIMITE" ]; do
  ESTADO="$(docker inspect -f '{{.State.Health.Status}}' "$CONTENEDOR" 2>/dev/null || echo desconocido)"
  if [ "$ESTADO" = "healthy" ]; then
    echo ""
    echo "      Base lista."
    break
  fi
  printf "."
  INTENTO=$((INTENTO + 1))
  sleep 2
done

if [ "$ESTADO" != "healthy" ]; then
  echo ""
  echo ""
  echo "ERROR: la base no respondio despues de 2 minutos (estado: $ESTADO)."
  echo "Revisa los logs con:  docker compose logs db"
  echo "Si el puerto 5432 ya lo usa otro Postgres tuyo, cambia POSTGRES_PORT"
  echo "en el .env (y la misma linea en DATABASE_URL) y vuelve a correr esto."
  exit 1
fi

# --- 4. Backend -------------------------------------------------
echo ""
echo "[4/6] Instalando el backend..."
bash backend/setup.sh

# --- 5. Frontend ------------------------------------------------
echo ""
echo "[5/6] Instalando el frontend..."
bash frontend/setup.sh

# --- 6. Comprobar que backend y base se hablan ------------------
echo ""
echo "[6/6] Comprobando que el backend se conecta a la base..."

if [ -f backend/.venv/bin/python ]; then
  VENV_PY=backend/.venv/bin/python
elif [ -f backend/.venv/Scripts/python.exe ]; then
  VENV_PY=backend/.venv/Scripts/python.exe
else
  echo ""
  echo "ERROR: no encuentro el entorno virtual del backend."
  exit 1
fi

# Se arranca en un puerto de prueba, no en el 8000, para no chocar con un
# backend que ya tengas abierto en otra terminal.
PUERTO_PRUEBA=8123
"$VENV_PY" -m uvicorn app.main:app --port "$PUERTO_PRUEBA" --app-dir backend \
  > /tmp/salud-backend.log 2>&1 &
PID_PRUEBA=$!

# Pase lo que pase de aqui en adelante, ese proceso se apaga.
trap 'kill "$PID_PRUEBA" 2>/dev/null || true' EXIT

INTENTO=0
RESPUESTA=""
while [ "$INTENTO" -lt 30 ]; do
  RESPUESTA="$(curl -s "http://127.0.0.1:$PUERTO_PRUEBA/api/salud" 2>/dev/null || true)"
  case "$RESPUESTA" in
    *'"bd":"ok"'*) break ;;
  esac
  printf "."
  INTENTO=$((INTENTO + 1))
  sleep 1
done

kill "$PID_PRUEBA" 2>/dev/null || true
# Esperar a que muera de verdad: si no, correr el setup dos veces seguidas
# encuentra el puerto de prueba todavia ocupado y falla sin motivo.
wait "$PID_PRUEBA" 2>/dev/null || true
trap - EXIT

echo ""
case "$RESPUESTA" in
  *'"bd":"ok"'*)
    echo "      El backend se conecta a la base. Todo listo."
    ;;
  *)
    echo ""
    echo "ERROR: el backend arranco pero no logro hablar con la base."
    echo "Respuesta recibida: ${RESPUESTA:-(ninguna)}"
    echo ""
    echo "Lo mas probable: DATABASE_URL en el .env no coincide con POSTGRES_PORT."
    echo "Detalle tecnico en /tmp/salud-backend.log"
    exit 1
    ;;
esac

# --- Listo ------------------------------------------------------
echo ""
echo "==================================================="
echo "  Listo. Levanta el proyecto en DOS terminales:"
echo "==================================================="
echo ""
echo "  Terminal 1 (API en el puerto 8000):"
echo "    cd backend && source .venv/bin/activate && uvicorn app.main:app --reload"
echo ""
echo "  Terminal 2 (interfaz en el puerto 5173):"
echo "    cd frontend && npm run dev"
echo ""
echo "  Y abre:  http://localhost:5173"
echo ""
echo "La base queda corriendo sola en Docker. Para apagarla:  docker compose stop"
echo ""
