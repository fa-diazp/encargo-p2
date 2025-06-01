FROM ubuntu:22.04

LABEL maintainer="fa-diazp@duocuc.cl"

ENV NAGIOS_VERSION=4.5.9
ENV NAGIOS_PLUGINS_VERSION=2.4.9
ENV DEBIAN_FRONTEND=noninteractive

# Instalación de dependencias
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    apache2 \
    apache2-utils \
    php \
    libapache2-mod-php \
    build-essential \
    libgd-dev \
    unzip \
    wget \
    curl \
    openssl \
    libssl-dev \
    daemon \
    make \
    libtool \
    libnet-snmp-perl \
    gettext \
    iputils-ping \
    dnsutils \
    sudo \
    ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Crear usuario y grupo para Nagios
RUN useradd nagios && \
    groupadd nagcmd && \
    usermod -a -G nagcmd nagios && \
    usermod -a -G nagcmd www-data

# Instalar Nagios Core
WORKDIR /tmp
RUN wget https://github.com/NagiosEnterprises/nagioscore/releases/download/nagios-${NAGIOS_VERSION}/nagios-${NAGIOS_VERSION}.tar.gz && \
    tar xzf nagios-${NAGIOS_VERSION}.tar.gz

WORKDIR /tmp/nagios-${NAGIOS_VERSION}
RUN ./configure --with-command-group=nagcmd && \
    make all && \
    make install && \
    make install-init && \
    make install-commandmode && \
    make install-config && \
    make install-webconf

RUN mkdir -p /usr/local/nagios/etc && \
    htpasswd -cb /usr/local/nagios/etc/htpasswd.users nagiosadmin nagiosadmin && \
    mkdir -p /usr/local/nagios/var && \
    chgrp -R nagcmd /usr/local/nagios/var && \
    chmod -R g+rw /usr/local/nagios/var

# Instalar Nagios Plugins
WORKDIR /tmp
RUN wget https://nagios-plugins.org/download/nagios-plugins-${NAGIOS_PLUGINS_VERSION}.tar.gz && \
    tar xzf nagios-plugins-${NAGIOS_PLUGINS_VERSION}.tar.gz

WORKDIR /tmp/nagios-plugins-${NAGIOS_PLUGINS_VERSION}
RUN ./configure --with-nagios-user=nagios --with-nagios-group=nagios && \
    make && \
    make install

# Activar módulos de Apache
RUN a2enmod cgi rewrite

# Crear script de entrada directamente
RUN echo '#!/bin/bash\n\
service apache2 start\n\
exec /usr/local/nagios/bin/nagios /usr/local/nagios/etc/nagios.cfg' \
> /entrypoint.sh && chmod +x /entrypoint.sh

# Exponer el puerto y definir el ENTRYPOINT usando formato JSON
EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
