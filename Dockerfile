FROM swipl:latest

WORKDIR /app

COPY . /app

EXPOSE 9000

CMD ["swipl", "-f", "src/server.pl"]
