# docker/Dockerfile - Nosso "cofre portátil"

FROM python:3.11-slim

# Criando usuário não-root (segurança!)
RUN useradd -m -u 1000 appuser

WORKDIR /app

# Copiando dependências primeiro (cache do Docker)
COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiando código da aplicação
COPY app/ .

# Trocando para usuário sem privilégios
USER appuser

# Variáveis de ambiente padrão (sem secrets!)
ENV PORT=5000
ENV ENVIRONMENT=production

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
