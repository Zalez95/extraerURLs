#!/usr/bin/perl -w

# Daniel González Alonso
# Programa para extraer las URLs de una página web dada por la entrada
# estándar que cumplen el estándar de la W3C.


@lineas = ();				# Lista donde introduciremos las lineas del texto.
@posibles_Urls = ();		# Lista donde introduciremos las posibles URLs.
@urls = ();					# Lista donde introduciremos las URLs correctas.


# 1. Leemos el texto de entrada y lo almacenamos en $texto_entrada.
while (<>)
{
	$texto_entrada .= $_;
}


# 2. Dividimos el texto en lineas.
@lineas = split( "\n", $texto_entrada );


# 3. Leemos todas las posibles URLs de las etiquetas <A> e <IMG> que haya en
# el texto y las almacenamos en la lista @posibles_Urls.
foreach( @lineas )
{
	$linea = $_;

	# Ancla <A>
	if( $linea =~ /.*\<[aA](.+)\>/ )
	{
		if( $1 =~ /\s(href|HREF)(=")([^"]+)(")/ )
		{
			# Si la URL pertenece a una etiqueta <A> añadimos un [A] delante.
			push(@posibles_Urls, "[A] $3");
		}
	}

	# Imagen <IMG>
	if( $linea =~ /.*\<(img|IMG)(.*)\>/ )
	{
		if( $2 =~ /\s(src|SRC)(=")([^"]+)(")/ )
		{
			# Si la URL pertenece a una etiqueta <IMG> añadimos un [I] delante.
			push(@posibles_Urls, "[I] $3");
		}
	}
}

# 4. Comprobamos que la URLs extraidas cumplen el estándar de la W3C.

# Banderas que nos indicarán si las distintas partes de la URL cumplen
# el estándar de la W3C: 0=no cumple, 1=si cumple.
$condHostport = 0;
$condPath = 0;
$condSearch = 0;

foreach( @posibles_Urls )
{
	$posibleUrl = $_;

	# url = http:// hostport [ / path ] [ ? search ]
	if( $posibleUrl =~ /(\[(A|I)\]\s)(http(s?):\/\/)([^\/]+)([^\?]*)([^\s]*)/ )
	{
		$hostport = $3;
		$path = $4;		# incluye / inicial.
		$search = $5;	# incluye ? inicial.

		# Nombre de la máquina.
		# hostport = host [ : port ]
		if( $hostport =~ /([^:])(:[0-9])?/ ) {
			$host = $1;

			# host = hostname | hostnumber
			if( $host =~ /([a-zA-Z]([0-9a-zA-Z]|\$|-|_|@|\.|\&|\+|-|!|\*|"|'|\(|\)|,|%[0-9a-fA-F]{2})*)(\.\g1)*/ )
			{
				$condHostport = 1;
			}
		}

		# Dirección en la máquina.
		if( $path =~ /(\/([0-9a-zA-Z]|\$|-|_|@|\.|\&|\+|-|!|\*|"|'|\(|\)|,|%[0-9a-fA-F]{2})*)*/ )
		{
			$condPath = 1;
		}

		# Query String.
		if( $search =~ /(\?([0-9a-zA-Z]|\$|-|_|@|\.|\&|\+|-|!|\*|"|'|\(|\)|,|%[0-9a-fA-F]{2})*)?/ )
		{
			$condSearch = 1;
		}

		# Si todas las partes de la URL cumplen el estándar se introducirán
		# en la lista @urls.
		if( ($condHostport == 1) && ($condPath == 1) && ($condSearch == 1) )
		{
			push(@urls, $posibleUrl);
		}

		# Reiniciamos las banderas.
		$condHostport = 0, $condPath = 0, $condSearch = 0;
	}
}

foreach( @urls )
{
	print "$_\n";
}
