-- Crear la tabla "continent" con "code" como clave primaria serial
CREATE TABLE "public"."continent" (
    "code" SERIAL PRIMARY KEY,
    "name" TEXT NOT NULL
);