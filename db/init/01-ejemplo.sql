-- Tabla del EJEMPLO borrable. Cuando el equipo defina su dominio real,
-- este archivo se borra y en su lugar va el esquema del proyecto.
--
-- Esto corre SOLO la primera vez, cuando docker crea el volumen vacio.
-- Para volver a aplicarlo: docker compose down -v && docker compose up -d

-- Por que "variantes" y no "productos": en calzado el stock NO vive en el
-- modelo, vive en la variante. La misma bota en talla 38 negra y en talla 40
-- cafe son dos inventarios distintos. Modelarlo al reves es el error clasico
-- del sector y obliga a rehacer media base despues.
CREATE TABLE IF NOT EXISTS variantes (
    id          SERIAL PRIMARY KEY,
    referencia  VARCHAR(120) NOT NULL,
    talla       INTEGER NOT NULL,
    color       VARCHAR(40) NOT NULL,
    stock       INTEGER NOT NULL DEFAULT 0,
    creado_en   TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Fijate como varias filas comparten 'referencia' y cada una lleva su stock.
INSERT INTO variantes (referencia, talla, color, stock) VALUES
    ('Bota chelsea cuero',      38, 'negro',  12),
    ('Bota chelsea cuero',      40, 'cafe',    5),
    ('Tenis lona urbano',       39, 'blanco', 30),
    ('Tenis lona urbano',       41, 'blanco',  0),
    ('Sandalia cuero trenzado', 37, 'miel',    8);
