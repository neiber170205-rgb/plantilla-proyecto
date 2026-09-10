import { useEffect, useState } from "react"
import { getProductos, postProducto } from "@/api/productos"
import type { NuevoProducto, Producto } from "@/api/productos"
import { ProductoForm } from "@/components/ProductoForm"
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

// La pantalla de ejemplo, y el patron a copiar: guarda el estado, le pide los datos
// a src/api/productos.ts y muestra los tres estados de toda peticion:
// cargando / error / datos.
export function Productos() {
  const [productos, setProductos] = useState<Producto[]>([])
  const [loading, setLoading] = useState(true)
  const [errorMessage, setErrorMessage] = useState("")

  // Cada llamada a la api se escribe igual: .then salio bien, .catch fallo,
  // .finally pase lo que pase ya termino.
  function loadProductos() {
    getProductos()
      .then(setProductos)
      .catch((error: Error) => setErrorMessage(error.message))
      .finally(() => setLoading(false))
  }

  // La funcion que recibe useEffect no puede ser async, por eso se usa .then.
  useEffect(() => {
    loadProductos()
  }, [])

  // setLoading(true) va aqui y no dentro de loadProductos porque al abrir la
  // pantalla loading ya arranca en true; solo hace falta volver a prenderlo
  // cuando se reintenta despues de un error.
  function onRetry() {
    setLoading(true)
    setErrorMessage("")
    loadProductos()
  }

  function handleCreate(nuevo: NuevoProducto): Promise<boolean> {
    setErrorMessage("")
    // El contrato dice que POST devuelve el producto creado con su id, asi que se
    // agrega ese a la lista y no hace falta volver a pedirla completa.
    // (actuales) => ... toma la lista mas reciente, no la del render viejo.
    return postProducto(nuevo)
      .then((creado) => {
        setProductos((actuales) => [...actuales, creado])
        return true
      })
      .catch((error: Error) => {
        setErrorMessage(error.message)
        return false
      })
  }

  return (
    <div className="grid gap-6">
      <Card>
        <CardHeader>
          <CardTitle>Nuevo producto</CardTitle>
          <CardDescription>POST /productos</CardDescription>
        </CardHeader>
        <CardContent>
          <ProductoForm onCreate={handleCreate} />
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Productos</CardTitle>
          <CardDescription>GET /productos</CardDescription>
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
          {loading && <p className="text-sm text-muted-foreground">Cargando productos...</p>}
          {!loading && productos.length === 0 && (
            <p className="text-sm text-muted-foreground">Todavia no hay productos.</p>
          )}
          {/* Las columnas son los tres campos que devuelve el contrato, ni uno mas:
              creado_en existe en la base de datos (docs/04-datos.md) pero
              GET /productos no lo manda. */}
          {!loading && productos.length > 0 && (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead className="w-16">Id</TableHead>
                  <TableHead>Nombre</TableHead>
                  <TableHead className="text-right">Stock</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {productos.map((producto) => (
                  <TableRow key={producto.id}>
                    <TableCell className="text-muted-foreground">{producto.id}</TableCell>
                    <TableCell>{producto.nombre}</TableCell>
                    <TableCell className="text-right">{producto.stock}</TableCell>
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
