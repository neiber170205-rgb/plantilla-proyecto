import path from "node:path"
import tailwindcss from "@tailwindcss/vite"
import react from "@vitejs/plugin-react"
import { defineConfig } from "vite"

export default defineConfig({
  plugins: [react(), tailwindcss()],
  // El .env es uno solo para todo el proyecto y vive en la raiz del repo.
  // Sin esta linea Vite lo buscaria dentro de frontend/ y no encontraria nada.
  // De ese archivo solo salen al navegador las variables que empiezan por VITE_,
  // asi que DATABASE_URL y demas nunca llegan al bundle.
  envDir: path.resolve(import.meta.dirname, ".."),
  resolve: {
    alias: {
      "@": path.resolve(import.meta.dirname, "./src"),
    },
  },
  server: {
    port: 5173,
  },
})
