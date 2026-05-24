FROM swipl:latest

WORKDIR /app

COPY datos.pl reglas.pl servidor.pl /app/

EXPOSE 8080

CMD ["swipl", "-q", "-f", "servidor.pl"]
