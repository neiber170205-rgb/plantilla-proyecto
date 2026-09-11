// EJEMPLO BORRABLE — no construyas tu dominio encima de este archivo.
//
// Lo unico del ejemplo que habla con el backend. Hay una funcion exportada por
// cada endpoint de docs/ejemplo-contrato.md, y ninguna mas: este archivo se lee
// al lado del contrato para comprobar que no se invento nada.

// Vite solo le entrega al navegador las variables que empiezan por VITE_.
// El valor real vive en el .env de la raiz del repo (ver .env.example).
const API_URL = import.meta.env.VITE_API_URL ?? "http://localhost:8000/api"

// Mientras el backend no responda, dejalo en true: la pantalla funciona con los
// datos falsos de abajo. Cuando el backend ya responda, ponlo en false.
// Se cambia a mano y a proposito, para que quede visible en el pull request.
export const USAR_DATOS_FALSOS = true

// La forma exacta que devuelven GET y POST /ejemplo/variantes.
export type Variante = {
  id: number
  referencia: string
  talla: number
  color: string
  stock: number
}

// La forma exacta que recibe POST. Va sin id: el id lo pone el backend.
export type NuevaVariante = {
  referencia: string
  talla: number
  color: string
  stock: number
}

// Fijate como varias filas comparten 'referencia' y cada una lleva su propio
// stock: en calzado el inventario vive en la variante, no en el modelo.
const VARIANTES_FALSAS: Variante[] = [
  { id: 1, referencia: "Bota chelsea cuero", talla: 38, color: "negro", stock: 12 },
  { id: 2, referencia: "Bota chelsea cuero", talla: 40, color: "cafe", stock: 5 },
  { id: 3, referencia: "Tenis lona urbano", talla: 39, color: "blanco", stock: 30 },
  { id: 4, referencia: "Tenis lona urbano", talla: 41, color: "blanco", stock: 0 },
  { id: 5, referencia: "Sandalia cuero trenzado", talla: 37, color: "miel", stock: 8 },
]

// GET /ejemplo/variantes -> 200 con la lista.
export async function getVariantes(): Promise<Variante[]> {
  if (USAR_DATOS_FALSOS) return [...VARIANTES_FALSAS]

  const response = await request(`${API_URL}/ejemplo/variantes`)
  return response.json()
}

// POST /ejemplo/variantes -> 201 con la variante creada, ya con su id.
export async function postVariante(nueva: NuevaVariante): Promise<Variante> {
  // Date.now() es un id inventado, solo para que la tabla tenga una key distinta.
  if (USAR_DATOS_FALSOS) return { id: Date.now(), ...nueva }

  const response = await request(`${API_URL}/ejemplo/variantes`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(nueva),
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
    throw new Error(
      `No se pudo conectar con ${API_URL}. Revisa que el backend este corriendo.`
    )
  }
  // Con 400, 404 o 500 fetch NO lanza error: hay que revisar response.ok a mano
  // o la pantalla se queda esperando datos que nunca llegan.
  if (!response.ok) throw new Error(getErrorMessage(response.status))

  return response
}

// Los codigos son los de la tabla "Errores" de docs/ejemplo-contrato.md.
function getErrorMessage(status: number): string {
  if (status === 400) return "Datos invalidos."
  if (status === 404) return "No existe el recurso."
  if (status === 500) return "Error del servidor."
  return `El servidor respondio ${status}.`
}
