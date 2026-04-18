# Configuración del entorno — CosmosFlutter

Dos formas de preparar el entorno de desarrollo. Elige la que se ajuste a tu flujo:

| Opción | Archivo | Cuándo usarla |
|---|---|---|
| **Docker** ⭐ recomendada | [docker.md](docker.md) | Entorno reproducible, CI, sin instalar Flutter en el host |
| **Local (sin Docker)** | [local.md](local.md) | Acceso directo a emuladores físicos, rendimiento máximo en el IDE |

---

## Variables de entorno requeridas

Independientemente del método elegido, necesitas un archivo `.env` en la raíz del proyecto:

```bash
cp .env.example .env
```

| Variable | Descripción | Cómo obtenerla |
|---|---|---|
| `NASA_API_KEY` | Clave gratuita de la NASA | [api.nasa.gov](https://api.nasa.gov/) |
| `SUPABASE_URL` | URL de tu proyecto Supabase | Panel → Settings → API |
| `SUPABASE_ANON_KEY` | Clave pública anon de Supabase | Panel → Settings → API |

> ⚠️ El archivo `.env` está en `.gitignore` — nunca lo commitees.
