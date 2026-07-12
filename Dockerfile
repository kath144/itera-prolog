FROM swipl:latest

WORKDIR /app

COPY . /app

EXPOSE 9000

# Healthcheck (usa python3 que esta disponible en la imagen swipl)
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
    CMD python3 -c "import urllib.request; urllib.request.urlopen('http://localhost:9000/health')" || exit 1

CMD ["swipl", "-f", "src/server.pl"]
