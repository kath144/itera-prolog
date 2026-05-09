FROM swipl:latest

WORKDIR /app

# Instalar dependencias adicionales si es necesario
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copiar archivos de la aplicación
COPY src/ src/
COPY requirements.txt .

# Exponer puerto
EXPOSE 9000

# Comando de inicio
CMD ["swipl", "-f", "src/server.pl"]
