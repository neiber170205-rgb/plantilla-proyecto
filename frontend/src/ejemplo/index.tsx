// EJEMPLO BORRABLE — no construyas tu dominio encima de este archivo.
//
// Esta es la pantalla del ejemplo, y el patron a copiar: guarda el estado, le
// pide los datos al cliente de api.ts y muestra los tres estados que tiene toda
// peticion: cargando / error / datos.
//
// Cuando definas tu dominio, copia este archivo a src/<tu-dominio>/ y borra
// la carpeta src/ejemplo/ completa.

import { useEffect, useState } from "react"
import { getVariantes, postVariante, USAR_DATOS_FALSOS } from "./api"
import type { NuevaVariante, Variante } from "./api"
import { VarianteForm } from "./VarianteForm"
import { Button } from "@/components/ui/button"
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"

export default function Variantes() {
  const [variantes, setVariantes] = useState<Variante[]>([])
  const [loading, setLoading] = useState(true)
  const [errorMessage, setErrorMessage] = useState("")

  // Cada llamada a la api se escribe igual: .then salio bien, .catch fallo,
  // .finally pase lo que pase ya termino.
  function loadVariantes() {
    getVariantes()
      .then(setVariantes)
      .catch((error: Error) => setErrorMessage(error.message))
      .finally(() => setLoading(false))
  }

  // La funcion que recibe useEffect no puede ser async, por eso se usa .then.
  useEffect(() => {
    loadVariantes()
  }, [])

  // setLoading(true) va aqui y no dentro de loadVariantes porque al abrir la
  // pantalla loading ya arranca en true; solo hace falta volver a prenderlo
  // cuando se reintenta despues de un error.
  function onRetry() {
    setLoading(true)
    setErrorMessage("")
    loadVariantes()
  }

  function handleCreate(nueva: NuevaVariante): Promise<boolean> {
    setErrorMessage("")
    // El contrato dice que POST devuelve la variante creada con su id, asi que
    // se agrega esa a la lista y no hace falta volver a pedirla completa.
    // (actuales) => ... toma la lista mas reciente, no la del render viejo.
    return postVariante(nueva)
      .then((creada) => {
        setVariantes((actuales) => [...actuales, creada])
        return true
      })
      .catch((error: Error) => {
        setErrorMessage(error.message)
        return false
      })
  }

  return (
    <div className="grid gap-6">
      {USAR_DATOS_FALSOS && (
        <p className="rounded-lg bg-muted px-3 py-2 text-sm text-muted-foreground">
          Estas viendo datos falsos, no el backend. Para conectarlo, pon
          USAR_DATOS_FALSOS en false dentro de src/ejemplo/api.ts.
        </p>
      )}

      <Card>
        <CardHeader>
          <CardTitle>Nueva variante</CardTitle>
          <CardDescription>POST /api/ejemplo/variantes</CardDescription>
        </CardHeader>
        <CardContent>
          <VarianteForm onCreate={handleCreate} />
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Variantes en inventario</CardTitle>
          <CardDescription>GET /api/ejemplo/variantes</CardDescription>
        </CardHeader>
        <CardContent className="grid gap-4">
          {errorMessage !== "" && (
            <div className="flex flex-wrap items-center justify-between gap-3 rounded-lg bg-destructive/10 px-3 py-2 text-sm text-destructive">
              <span>{errorMessage}</span>
              <Button variant="outline" size="sm" onClick={onRetry}>
                Reintentar
              </Button>
            </div>
          )}
          {loading && (
            <p className="text-sm text-muted-foreground">Cargando variantes...</p>
          )}
          {!loading && variantes.length === 0 && (
            <p className="text-sm text-muted-foreground">Todavia no hay variantes.</p>
          )}
          {/* Las columnas son los campos que devuelve el contrato, ni uno mas:
              creado_en existe en la tabla pero el contrato no lo manda. */}
          {!loading && variantes.length > 0 && (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Referencia</TableHead>
                  <TableHead className="w-20">Talla</TableHead>
                  <TableHead className="w-28">Color</TableHead>
                  <TableHead className="w-20 text-right">Stock</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {variantes.map((variante) => (
                  <TableRow key={variante.id}>
                    <TableCell>{variante.referencia}</TableCell>
                    <TableCell>{variante.talla}</TableCell>
                    <TableCell className="text-muted-foreground">
                      {variante.color}
                    </TableCell>
                    <TableCell className="text-right">{variante.stock}</TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          )}
        </CardContent>
      </Card>
    </div>
  )
}
