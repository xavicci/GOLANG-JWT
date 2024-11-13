# Usamos una imagen base oficial de PostgreSQL que ya tiene PostGIS preinstalado
FROM postgis/postgis:16-3.4

# Establecer variables de entorno para configuración
ENV POSTGRES_USER=userbank
ENV POSTGRES_PASSWORD=Lovecraft.00
ENV POSTGRES_DB=simplebank


RUN apt-get update && apt-get install -y wget \
    && wget https://go.dev/dl/go1.23.1.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.23.1.linux-amd64.tar.gz \
    && rm go1.23.1.linux-amd64.tar.gz \
    && echo "export PATH=\$PATH:/usr/local/go/bin" >> /etc/profile
# Exponer el puerto de PostgreSQL (5432 por defecto)

# Volumenes para PostGIS y GO
VOLUME ["/var/lib/postgresql/data", "/app"]

# Establecer el directorio de trabajo para Go
WORKDIR /app

# Copiar el código fuente de Go al contenedor
COPY . /app

EXPOSE 5432
EXPOSE 8080
# Comando por defecto para iniciar PostgreSQL con PostGIS
CMD ["postgres"]