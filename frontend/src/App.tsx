import type { ComponentType } from "react"
import { Package } from "lucide-react"

// El ejemplo es borrable, y este archivo NO se toca al borrarlo.
//
// Por eso el ejemplo no se importa con un import normal: un import a una
// carpeta que ya no existe rompe 'npm run build'. import.meta.glob es de Vite
// y se resuelve al compilar: si src/ejemplo/ existe, lo carga; si la borraste,
// queda un objeto vacio y la app sigue compilando igual.
const modulos = import.meta.glob<{ default: ComponentType }>("./ejemplo/index.tsx", {
  eager: true,
})
const PantallaEjemplo = Object.values(modulos)[0]?.default

// La plantilla tiene una sola pantalla. Cuando haya mas, aqui se decide cual se ve.
function App() {
  return (
    <div className="min-h-svh bg-background p-6">
      <header className="mx-auto mb-6 flex max-w-4xl items-center gap-2">
        <Package className="size-5" />
        {/* Cambia esto por el nombre real del proyecto. */}
        <h1 className="font-heading text-lg font-medium">NOMBRE DEL PROYECTO</h1>
      </header>

      <main className="mx-auto grid max-w-4xl gap-6">
        {PantallaEjemplo ? <PantallaEjemplo /> : <SinEjemplo />}
      </main>
    </div>
  )
}

// Lo que se ve despues de borrar el ejemplo: el punto de partida del equipo.
function SinEjemplo() {
  return (
    <div className="rounded-lg border border-dashed p-6 text-sm text-muted-foreground">
      <p className="mb-2 font-medium text-foreground">Aqui va tu primera pantalla.</p>
      <p>
        Borraste el ejemplo, que era lo correcto. Crea tu carpeta en{" "}
        <code>src/</code> siguiendo el patron que traia <code>src/ejemplo/</code>:
        un archivo que hable con la api, un formulario y la pantalla.
      </p>
    </div>
  )
}

export default App
