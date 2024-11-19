# Usando a imagem base do Python
FROM python:3.9-slim

# Instala as dependências necessárias
RUN apt-get update && apt-get install -y libpq-dev gcc

# Defina o diretório de trabalho no contêiner
WORKDIR /app

# Copiar o arquivo requirements.txt para o diretório /app
COPY app/. /app/

# Instalar as dependências
RUN pip install --no-cache-dir -r /app/requirements.txt

# Expõe a porta 5000 para a aplicação Flask
EXPOSE 5000

# Defina o comando para rodar a aplicação
CMD ["python", "app.py"]
