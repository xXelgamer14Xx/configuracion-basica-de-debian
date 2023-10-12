#!/bin/bash

# Configuración del PATH para todos los usuarios
echo 'export PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin' >> /etc/environment

# Configuración del PATH para el usuario malu
echo 'export PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin' >> /home/malu/.bashrc

# Configuración del PATH para el usuario root
echo 'export PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin' >> /root/.bashrc

# Validar y configurar la fecha y hora
date
date --set "2023-06-01 21:12:00"

# Configuración del sources.list
nano /etc/apt/sources.list

# Actualizar la lista de paquetes
apt-get update

# Instalar aplicaciones/servicios
# Reemplaza "nombre_del_paquete" con el nombre del paquete que deseas instalar
apt-get install nombre_del_paquete -y

# Instalar entorno gráfico
# Reemplaza "nombre_del_entorno" con el nombre del entorno que deseas instalar (xfce4, lxde, gnome, kde-full)
apt-get install xserver-xorg nombre_del_entorno slim -y

# Instalar Putty
apt-get install putty -y

# Instalar Midori (navegador)
apt-get install midori -y

# Configuración de tarjetas de red
# Modifica los adaptadores de red según sea necesario

# Para el adaptador NAT en Debian_cliente:
ip link set enp0s3 down
ip link set enp0s3 name NAT

# Para el adaptador de red interna en Debian_cliente:
ip link set enp0s8 down
ip link set enp0s8 name RedInterna

# Configura la dirección IP de la tarjeta de red interna en Debian_cliente:
ip addr add 192.168.1.2/24 dev RedInterna
ip link set RedInterna up

# Configura la dirección IP de la tarjeta de red interna en Debian_servidor:
ip addr add 192.168.1.1/24 dev RedInterna
ip link set RedInterna up

# Habilita el enrutamiento en Debian_servidor si es necesario:
echo '1' > /proc/sys/net/ipv4/ip_forward

# Activa el reenvío de paquetes en Debian_servidor:
iptables -A FORWARD -i RedInterna -o NAT -j ACCEPT
iptables -A FORWARD -i NAT -o RedInterna -j ACCEPT

# Guarda las reglas de iptables
iptables-save > /etc/iptables.rules

# Carga las reglas de iptables en el arranque
echo 'up iptables-restore < /etc/iptables.rules' >> /etc/network/interfaces

# Reinicia el servicio de red
service networking restart

# Reinicia la máquina si es necesario
