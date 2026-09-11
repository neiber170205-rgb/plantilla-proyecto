// EJEMPLO BORRABLE — no construyas tu dominio encima de este archivo.

import { useState } from "react"
import type { FormEvent } from "react"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import type { NuevaVariante } from "./api"

type Props = {
  // Devuelve true si la variante quedo creada; solo entonces se limpian los campos.
  onCreate: (nueva: NuevaVariante) => Promise<boolean>
}

export function VarianteForm({ onCreate }: Props) {
  const [referencia, setReferencia] = useState("")
  const [talla, setTalla] = useState("")
  const [color, setColor] = useState("")
  const [stock, setStock] = useState("")
  const [saving, setSaving] = useState(false)

  function onSubmit(event: FormEvent) {
    event.preventDefault()
    setSaving(true)
    onCreate({
      referencia,
      talla: Number(talla),
      color,
      stock: Number(stock),
    })
      .then((creada) => {
        if (creada) {
          setReferencia("")
          setTalla("")
          setColor("")
          setStock("")
        }
      })
      .finally(() => setSaving(false))
  }

  // required y type="number" son validacion de formulario, no reglas de negocio:
  // es lo minimo para que Number() no llegue como NaN al JSON del POST.
  // Las reglas de negocio se escriben primero en docs/01-requisitos.md
  // (RN-01, RN-02...), y hoy no hay ninguna: aqui no se inventa ninguna.
  return (
    <form onSubmit={onSubmit} className="flex flex-wrap items-end gap-3">
      <div className="grid min-w-44 flex-1 gap-1.5">
        <Label htmlFor="referencia">Referencia</Label>
        <Input
          id="referencia"
          value={referencia}
          placeholder="Bota chelsea cuero"
          onChange={(event) => setReferencia(event.target.value)}
          required
        />
      </div>
      <div className="grid w-24 gap-1.5">
        <Label htmlFor="talla">Talla</Label>
        <Input
          id="talla"
          type="number"
          value={talla}
          placeholder="38"
          onChange={(event) => setTalla(event.target.value)}
          required
        />
      </div>
      <div className="grid w-32 gap-1.5">
        <Label htmlFor="color">Color</Label>
        <Input
          id="color"
          value={color}
          placeholder="negro"
          onChange={(event) => setColor(event.target.value)}
          required
        />
      </div>
      <div className="grid w-24 gap-1.5">
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
      {/* Deshabilitado mientras guarda, para que dos clics no creen dos variantes. */}
      <Button type="submit" disabled={saving}>
        {saving ? "Guardando..." : "Agregar"}
      </Button>
    </form>
  )
}
