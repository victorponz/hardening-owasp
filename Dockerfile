#Indicar la imagen de DockerHub a utilizar, en este caso Debian
FROM debian

#Establecer variables de zona y para que no nos salgan errores de frontend
ENV TZ=Europe/Madrid
ENV DEBIAN_FRONTEND=noninteractive

#Instalación de modsecurity, apache y php
RUN apt-get update -qq >/dev/null && apt-get install -y git libapache2-mod-security2 apache2 php7.4 >/dev/null 2>/dev/null

WORKDIR /tmp/
RUN git clone https://github.com/SpiderLabs/owasp-modsecurity-crs.git
WORKDIR /tmp/owasp-modsecurity-crs
RUN mv crs-setup.conf.example /etc/modsecurity/crs-setup.conf
RUN mv rules/ /etc/modsecurity
COPY security2.conf /etc/apache2/mods-enabled/security2.conf
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
#Directorio por defecto
WORKDIR /var/www/html

#Copia de los archivos de la página, el entrypoint, el fichero de configuración de apache y el fichero de configuración de modsecurity
COPY public_html /var/www/html/public_html/

COPY entrypoint.sh /var/www/html/

RUN echo "ServerTokens ProductOnly" >> /etc/apache2/apache2.conf
RUN echo "ServerSignature Off" >> /etc/apache2/apache2.conf

#Deshabilitar el módulo que indexa los directorios
RUN  a2dismod -f autoindex.load
#Indicar el entrypoint
CMD ["./entrypoint.sh"]
