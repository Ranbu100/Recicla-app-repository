# Estágio de construção
FROM dart:2.17.6 AS build

WORKDIR /app

# Copie todos os arquivos necessários para o diretório de trabalho
COPY . .

# Instale as dependências do Dart
RUN dart pub get

# Verifique se o arquivo server.dart está acessível
RUN ls -la bin/backend.dart

# Compile o aplicativo Dart
RUN dart compile exe bin/backend.dart -o /app/bin/backend

# Estágio de execução
FROM debian:latest

# Instale dependências necessárias, como libpq para PostgreSQL
RUN apt-get update && apt-get install -y libpq-dev

# Defina o diretório de trabalho
WORKDIR /app

# Copie os arquivos necessários da imagem de build
COPY --from=build /app/bin/backend /app/backend
COPY --from=build /app/specs /app/specs
COPY wait-for-it.sh /app/wait-for-it.sh

# Adicionar permissão de execução para wait-for-it.sh
RUN chmod +x /app/wait-for-it.sh

# Defina as variáveis de ambiente
ENV DB_HOST=34.95.225.54
ENV DB_PORT=3306
ENV DB_USER=postgres
ENV DB_PASSWORD=yourpassword
ENV DB_NAME=postgres

# Comando para iniciar o aplicativo
CMD ["/app/wait-for-it.sh", "34.95.225.54:3306", "--", "/app/server"]
