# 🧠 Itera Prolog - Motor de Lógica

Motor de lógica declarativa para la plataforma Itera basado en SWI-Prolog con API HTTP REST.

## 📋 Descripción

Este servicio proporciona un motor de lógica (Rules Engine) que puede ser consultado por otros microservicios mediante HTTP. Implementa la lógica de negocio mediante reglas y hechos en Prolog.

## 🚀 Inicio Rápido

### Con Docker
```bash
docker build -t itera-prolog .
docker run -p 9000:9000 itera-prolog
```

### Local
```bash
# Instalar SWI-Prolog: https://www.swi-prolog.org/Download.html

swipl -f server.pl
```

El servidor estará disponible en `http://localhost:9000`

## 📁 Estructura

```
itera-prolog/
├── src/
│   ├── server.pl              # Servidor HTTP principal
│   ├── rules/
│   │   ├── business_rules.pl  # Reglas de negocio
│   │   └── facts.pl           # Hechos base
│   └── utils/
│       └── helpers.pl         # Funciones auxiliares
├── tests/
│   └── test_rules.pl          # Tests de reglas
├── Dockerfile
├── requirements.txt           # Dependencias
└── README.md
```

## 🔌 API HTTP

### Health Check
```bash
GET /health
```

**Respuesta:**
```json
{
  "status": "ok",
  "service": "itera-prolog",
  "version": "1.0.0"
}
```

### Query Prolog
```bash
POST /query
Content-Type: application/json

{
  "query": "miembro(X, [1,2,3])"
}
```

**Respuesta exitosa:**
```json
{
  "success": true,
  "solutions": [
    {"X": "1"},
    {"X": "2"},
    {"X": "3"}
  ]
}
```

**Respuesta sin soluciones:**
```json
{
  "success": false,
  "solutions": []
}
```

### Query con Timeout
```bash
POST /query
Content-Type: application/json

{
  "query": "fibonacci(40, X)",
  "timeout": 5000
}
```

## 💡 Ejemplos de Uso

### Desde Angular
```typescript
async consultarLogica(query: string) {
  const response = await fetch('http://localhost:9000/query', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ query })
  });
  return response.json();
}
```

### Desde Scala
```scala
val query = "regla_negocio(X)"
val response = Http("http://localhost:9000/query")
  .postData(s"""{"query": "$query"}""")
  .asString
```

### Desde Python
```python
import requests

query = "condicional(X, Y)"
response = requests.post(
  'http://localhost:9000/query',
  json={'query': query}
)
solutions = response.json()['solutions']
```

## 📝 Reglas Base

El archivo `src/rules/business_rules.pl` contiene:

```prolog
% Hechos
miembro(X, [X|_]).
miembro(X, [_|T]) :- miembro(X, T).

% Reglas
adulto(Edad) :- Edad >= 18.

% Condicionales
clasificar(X, mayor) :- X > 10, !.
clasificar(_, menor).
```

## 🧪 Tests

```bash
swipl -f tests/test_rules.pl
```

## 🔧 Configuración

Variables de entorno:
- `PROLOG_PORT=9000` - Puerto del servidor
- `PROLOG_TIMEOUT=30000` - Timeout de queries en ms
- `PROLOG_MAX_SOLUTIONS=1000` - Máximo de soluciones

## 📚 Documentación Prolog

- [SWI-Prolog Manual](https://www.swi-prolog.org/pldoc/doc_for?object=manual)
- [Prolog Basics](https://www.swi-prolog.org/pldoc/doc_for?object=tutorial)

## 🤝 Integración con Otros Servicios

Este servicio es consumido por:
- **itera-angular** - Consultas de lógica desde frontend
- **Itera (Scala)** - Validaciones y reglas de negocio
- **Itera-python** - Procesamiento lógico de datos

## 📄 Licencia

MIT

---

**Puerto**: 9000  
**Última actualización**: Mayo 2026
