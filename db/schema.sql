-- Esquema del proyecto. Ver docs/04-datos.md

CREATE TABLE IF NOT EXISTS productos (
    id          SERIAL PRIMARY KEY,
    nombre      VARCHAR(120) NOT NULL,
    stock       INTEGER NOT NULL DEFAULT 0,
    creado_en   TIMESTAMP NOT NULL DEFAULT NOW()
);
