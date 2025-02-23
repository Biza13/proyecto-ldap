# Usar la imagen base de ubuntu
FROM ubuntu:latest

# Actualizar e instalar Apache, Node.js y npm
RUN apt update -y && \
    apt install -y apache2 && \
    # Instalar Node.js
    apt install -y nodejs && \
    # Instalar npm
    apt install -y npm && \
    #instalar sass globalmente (creo que no hace falta)
    npm install -g sass && \
    # Instalar nano
    apt install nano -y && \
    #instalar ldap utils
    apt install ldap-utils && \
    #instalar openssl
    apt install -y openssl && \
    # Limpiar los archivos de cache de apt para reducir el tamaño de la imagen
    apt clean

# Copia los archivos de tu página web al contenedor
COPY ./index.html /var/www/html
COPY ./ProyectoEnSASS-Restaurante /var/www/html/ProyectoEnSASS-Restaurante

# Copiar los certificados al contenedor
COPY certificado/certificate.crt /etc/ssl/certs/
COPY certificado/private.key /etc/ssl/private/
COPY certificado/ca_bundle.crt /etc/ssl/certs/

#copiar los default a su carpeta
COPY ./default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf

# Esto (a2ensite) es para habilitar el archivo default-ssl.conf, aunque por defecto viene habilitado

# habilitar SSL y el ldap  (modulos)
RUN a2enmod ssl && \
    a2ensite default-ssl.conf && \
    a2enmod authnz_ldap ldap && \
    a2enmod rewrite

# dar permisos a las carpetas 
RUN chown -R www-data:www-data /var/www/html/ProyectoEnSASS-Restaurante && \
    chmod -R 755 /var/www/html/ProyectoEnSASS-Restaurante

# moverse a la carpeta de la pagina e instalar sass
RUN cd /var/www/html/ProyectoEnSASS-Restaurante && \
    npm init -y && \
    npm install -D sass

# Expone el puerto 443 para Apache que es el https y el 3000 para el json y el 80 para la redireccion
EXPOSE 443
EXPOSE 80

#lanzamos aqui el apache
CMD ["sh", "-c", "apachectl -D FOREGROUND"]