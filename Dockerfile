# Etapa 1: Build (opcional para instalar dependencias)
FROM python:3.11-slim AS builder
WORKDIR /app

# Instalar dependencias de sistema necesarias para compilar (ej. gcc)
RUN apt-get update && apt-get install -y gcc

# Copiar el fichero de requerimientos y preinstalar dependencias
COPY requirements.txt .
RUN pip install --upgrade pip && pip install --user -r requirements.txt

# Etapa 2: Imagen final
FROM python:3.11-slim
WORKDIR /app

# Crear un usuario no root para mayor seguridad
RUN adduser --disabled-password appuser
USER appuser

# Copiar dependencias instaladas en la etapa builder
COPY --from=builder /root/.local /home/appuser/.local
ENV PATH="/home/appuser/.local/bin:${PATH}"

# Copiar el código de la aplicación (se copia todo el contenido del proyecto)
COPY --chown=appuser:appuser . .

# Definir variables de entorno necesarias
ENV PORT=8000
ENV DJANGO_SETTINGS_MODULE=demo_devops.settings
ENV PYTHONUNBUFFERED=1

# Exponer el puerto en el que correrá la aplicación
EXPOSE ${PORT}

# Agregar un chequeo de salud para que Docker pueda verificar que la app responde
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD curl -f http://localhost:${PORT}/api/ || exit 1

# Ejecutar las migraciones y levantar el servidor
CMD ["sh", "-c", "py manage.py migrate && py manage.py runserver 0.0.0.0:${PORT}"]
