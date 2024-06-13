# Use a imagem Dart para compilar a aplicação
FROM dart:2.17.6 AS build

# Defina o diretório de trabalho
WORKDIR /app

# Copie os arquivos pubspec e obtenha as dependências
COPY pubspec.* ./
RUN dart pub get

# Copie o código-fonte da aplicação
COPY . .

# Garanta que os pacotes estejam atualizados, mesmo offline
RUN dart pub get --offline

# Compile a aplicação para um executável AOT
RUN dart compile exe bin/backend.dart -o bin/server

# Use uma imagem mínima para a execução
FROM gcr.io/distroless/base-debian10

# Copie os arquivos necessários da imagem de build
COPY --from=build /app/bin/server /server
COPY --from=build /app/specs /specs

# Defina as variáveis de ambiente
ENV DATABASE_URL=postgresql://postgres:qwe123@localhost:5432/postgres
ENV JWT_KEY=dihfiUHFoiudhfosfF1e5sf1s1f5f1EF15

# Exponha a porta em que o servidor vai rodar
EXPOSE 4466

# Comando para iniciar o servidor
CMD ["/server"]
