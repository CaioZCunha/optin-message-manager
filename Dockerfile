FROM python:3.11-slim

WORKDIR /app

# Dependências do sistema
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    unixodbc \
    unixodbc-dev \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Adicionar chave da Microsoft (modo moderno)
RUN mkdir -p /etc/apt/keyrings && \
    curl -sSL https://packages.microsoft.com/keys/microsoft.asc \
    | gpg --dearmor \
    | tee /etc/apt/keyrings/microsoft.gpg > /dev/null

# Adicionar repositório Microsoft
RUN echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/debian/12/prod bookworm main" \
    > /etc/apt/sources.list.d/mssql-release.list

# Instalar driver ODBC
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql18

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
