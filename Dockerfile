FROM python:3.11-slim

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar archivos necesarios
COPY requirements.txt .

# Instalar dependencias
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el resto de la aplicación
COPY . .

# Crear usuario no root y cambiar permisos
RUN useradd -m appuser && chown -R appuser /app
USER appuser

# Exponer el puerto
EXPOSE 8000

# Definir variables de entorno
ENV PYTHONUNBUFFERED=1

# Ejecutar migraciones y arrancar el servidor en modo desarrollo
CMD ["sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"]

