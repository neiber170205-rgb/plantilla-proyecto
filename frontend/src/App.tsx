import { Package } from "lucide-react"
import { USAR_DATOS_FALSOS } from "@/api/productos"
import { Productos } from "@/components/Productos"

// La plantilla tiene una sola pantalla. Cuando haya mas, aqui se decide cual se ve.
function App() {
  return (
    <div className="min-h-svh bg-background p-6">
      <header className="mx-auto mb-6 flex max-w-3xl items-center gap-2">
        <Package className="size-5" />
        {/* Cambia esto por el nombre real del proyecto. */}
        <h1 className="font-heading text-lg font-medium">Semillero SINDES</h1>
      </header>

      <main className="mx-auto grid max-w-3xl gap-6">
        {USAR_DATOS_FALSOS && (
          <p className="rounded-lg bg-muted px-3 py-2 text-sm text-muted-foreground">
            Estas viendo datos falsos, no el backend. Para conectarlo, pon
            USAR_DATOS_FALSOS en false dentro de src/api/productos.ts.
          </p>
        )}

        <Productos />
      </main>
    </div>
  )
}

export default App
