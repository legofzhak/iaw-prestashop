# Práctica: Instalación de PrestaShop usando contenedores Docker y Docker Compose

## Requisitos
---
1. Crear una máquina en AWS EC2 con mas de 2Gb de RAM, para evitar posibles problemas.

2. Instalar Docker y Docker compose ejecutando el script [install_docker.sh](install_docker.sh).


## Configuración para desplegar bitnami/prestashop en Docker compose
--- 
En la siguiente configuración se despliegan 4 Imagenes: [bitnami/prestashop](https://hub.docker.com/r/bitnami/prestashop), [MySQL](https://hub.docker.com/_/mysql), [phpMyAdmin](https://hub.docker.com/_/phpmyadmin) y [steveltn/https-portal
](https://hub.docker.com/r/steveltn/https-portal).

```YML
version: '3.3'

services:
  prestashop:
    image: bitnami/prestashop:1.7
    environment:
      - PRESTASHOP_FIRST_NAME=${PRESTASHOP_FIRST_NAME}
      - PRESTASHOP_LAST_NAME=${PRESTASHOP_LAST_NAME}
      - PRESTASHOP_PASSWORD=${PRESTASHOP_PASSWORD}
      - PRESTASHOP_EMAIL=${PRESTASHOP_EMAIL}
      - PRESTASHOP_COUNTRY=${PRESTASHOP_COUNTRY}
      - PRESTASHOP_LANGUAGE=${PRESTASHOP_LANGUAGE}
      - PRESTASHOP_DATABASE_HOST=${PRESTASHOP_DATABASE_HOST}
      - PRESTASHOP_HOST=${PRESTASHOP_HOST}
      - PRESTASHOP_ENABLE_HTTPS=${PRESTASHOP_ENABLE_HTTPS}
      - PRESTASHOP_DATABASE_NAME=${MYSQL_DATABASE}
      - PRESTASHOP_DATABASE_USER=${MYSQL_USER}
      - PRESTASHOP_DATABASE_PASSWORD=${MYSQL_PASSWORD}
    restart: always
    volumes:
      - prestashop_data:/bitnami/prestashop
    depends_on:
      - mariadb
    networks:
      - frontend_network
      - backend_network
  
  mariadb:
    image: mariadb:10.4
    environment:
      - MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
      - MYSQL_DATABASE=${MYSQL_DATABASE}
      - MYSQL_USER=${MYSQL_USER}
      - MYSQL_PASSWORD=${MYSQL_PASSWORD}
    restart: always
    volumes:
      - mariadb_data:/var/lib/mysql
    networks:
      - backend_network
    security_opt:
      - seccomp:unconfined

  phpmyadmin:
    image: phpmyadmin:5
    restart: always
    ports:
      - 8080:80
    environment:
      - PMA_HOST=mariadb
    depends_on:
      - mariadb
    networks:
      - frontend_network
      - backend_network

  https-portal:
    image: steveltn/https-portal
    ports:
      - 80:80
      - 443:443
    environment:
      #DOMAINS: 'localhost -> http://prestashop:80 #local'
      DOMAINS: 'dk-zelk.ddns.net -> http://prestashop:8080 #production'
    volumes:
      - ssl_certs_data:/var/lib/https-portal
    depends_on:
      - prestashop
    restart: always
    networks:
      - frontend_network

volumes:
  prestashop_data:
  mariadb_data:
  ssl_certs_data:

networks:
  frontend_network:
  backend_network:
```

## Comprobamos la funcionalidad
---

Desplegamos el servicio con `docker-compose up -d`.
