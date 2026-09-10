// Lo unico que habla con el backend.
// Hay una funcion exportada por cada endpoint de docs/03-api.md, y ninguna mas:
// este archivo se lee al lado del contrato para comprobar que no se invento nada.

// Vite solo le entrega al navegador las variables que empiezan por VITE_.
// El valor real vive en el .env de la raiz del repo (ver .env.example).
const API_URL = import.meta.env.VITE_API_URL ?? "http://localhost:8000/api"

// Mientras el backend no responda /productos, dejalo en true: la pantalla funciona
// con los datos falsos de abajo. Cuando el backend ya responda, ponlo en false.
// Se cambia a mano y a proposito, para que quede visible en el pull request.
export const USAR_DATOS_FALSOS = true

// La forma exacta que devuelven GET /productos y POST /productos.
export type Producto = {
  id: number
  nombre: string
  stock: number
}

// La forma exacta que recibe POST /productos. Va sin id: el id lo pone el backend.
export type NuevoProducto = {
  nombre: string
  stock: number
}

const PRODUCTOS_FALSOS: Producto[] = [
  { id: 1, nombre: "Bota cuero", stock: 12 },
  { id: 2, nombre: "Tenis lona", stock: 30 },
]

// GET /productos -> 200 con la lista de productos.
export async function getProductos(): Promise<Producto[]> {
  if (USAR_DATOS_FALSOS) return [...PRODUCTOS_FALSOS]

  const response = await request(`${API_URL}/productos`)
  return response.json()
}

// POST /productos -> 201 con el producto creado, ya con su id.
export async function postProducto(nuevo: NuevoProducto): Promise<Producto> {
  // Date.now() es un id inventado, solo para que la tabla tenga una key distinta.
  if (USAR_DATOS_FALSOS) return { id: Date.now(), ...nuevo }

  const response = await request(`${API_URL}/productos`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(nuevo),
  })
  return response.json()
}

// Las dos funciones de arriba pasan por aqui para no repetir el manejo de errores.
async function request(url: string, options?: RequestInit): Promise<Response> {
  let response: Response
  try {
    response = await fetch(url, options)
  } catch {
    // fetch solo lanza error cuando la peticion ni siquiera llego: backend
    // apagado, sin red o falta CORS. Su "Failed to fetch" no le dice nada a nadie.
    throw new Error(`No se pudo conectar con ${API_URL}. Revisa que el backend este corriendo.`)
  }
  // Con 400, 404 o 500 fetch NO lanza error: hay que revisar response.ok a mano
  // o la pantalla se queda esperando datos que nunca llegan.
  if (!response.ok) throw new Error(getErrorMessage(response.status))

  return response
}

// Los codigos son los de la tabla "Errores" de docs/03-api.md.
function getErrorMessage(status: number): string {
  if (status === 400) return "Datos invalidos."
  if (status === 404) return "No existe el recurso."
  if (status === 500) return "Error del servidor."
  return `El servidor respondio ${status}.`
}
