import { useState } from "react"
import type { FormEvent } from "react"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import type { NuevoProducto } from "@/api/productos"

type Props = {
  // Devuelve true si el producto quedo creado; solo entonces se limpian los campos.
  onCreate: (nuevo: NuevoProducto) => Promise<boolean>
}

export function ProductoForm({ onCreate }: Props) {
  const [nombre, setNombre] = useState("")
  const [stock, setStock] = useState("")
  const [saving, setSaving] = useState(false)

  function onSubmit(event: FormEvent) {
    event.preventDefault()
    setSaving(true)
    onCreate({ nombre, stock: Number(stock) })
      .then((creado) => {
        if (creado) {
          setNombre("")
          setStock("")
        }
      })
      .finally(() => setSaving(false))
  }

  // required y type="number" son validacion de formulario, no reglas de negocio:
  // es lo minimo para que Number(stock) no llegue como NaN al JSON del POST.
  // Las reglas de negocio se escriben primero en docs/01-requisitos.md
  // (RN-01, RN-02...), y hoy no hay ninguna: aqui no se inventa ninguna.
  return (
    <form onSubmit={onSubmit} className="flex flex-wrap items-end gap-3">
      <div className="grid min-w-40 flex-1 gap-1.5">
        <Label htmlFor="nombre">Nombre</Label>
        <Input
          id="nombre"
          value={nombre}
          placeholder="Bota cuero"
          onChange={(event) => setNombre(event.target.value)}
          required
        />
      </div>
      <div className="grid w-28 gap-1.5">
        <Label htmlFor="stock">Stock</Label>
        <Input
          id="stock"
          type="number"
          value={stock}
          placeholder="12"
          onChange={(event) => setStock(event.target.value)}
          required
        />
      </div>
      {/* Deshabilitado mientras guarda, para que dos clics no creen dos productos. */}
      <Button type="submit" disabled={saving}>
        {saving ? "Guardando..." : "Agregar"}
      </Button>
    </form>
  )
}
