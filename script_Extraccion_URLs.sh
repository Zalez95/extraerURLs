#!/bin/bash

# Daniel Gonzalez Alonso
# Script (en BASH) que toma como entrada la entrada estandar o la URL de
# una pagina web y que devuelve en la salida los enlaces que aparecen en ella.

case "$1" in
		-u)	# Si se usa -u como parametro, descargaremos la pagina web.
			url=$2	# URL de la pagina web
			if wget -q --user-agent="Mozilla/4.0" --spider $url
			then
				# Descargamos la pagina web y la pasamos como argumento del programa de extraccion de URLs.
				wget -qO- --user-agent="Mozilla/4.0" "$url" | perl extraerURLs.pl
			fi
			;;
		*)	# Por defecto leemos de la entrada estandar.
			perl extraerURLs.pl < "${VAR:-/dev/stdin}"
			;;
esac
