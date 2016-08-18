<a name="inicio"></a>		
Todo Pago - módulo SDK-Ruby para conexión con gateway de pago
=======

 + [Instalación](#instalacion)
 	+ [Creación de la gema TodoPagoConector](#creategem)
 	+ [Instalación de la gema TodoPagoConector](#installgem)
 	+ [Versiones de Ruby soportadas](#Versionesderubysoportadas)
 	+ [Generalidades](#general)
 + [Uso](#uso)		
    + [Inicializar la clase correspondiente al conector (TodoPagoConector)](#initconector)
    + [Solicitud de autorización](#solicitudautorizacion)
    + [Confirmación de transacción](#confirmatransaccion)
    + [Ejemplo](#ejemplo)
    + [Modo test](#test)
 + [Datos adicionales para prevención de fraude](#datosadicionales) 
    + [Datos de referencia](#datosreferencia) 
 + [Características](#caracteristicas)
    + [Status de la operación](#status)
    + [Consulta de operaciones por rango de tiempo](#statusdate)
    + [Devolucion](#devolucion)
    + [Devolucion parcial](#devolucionparcial)
    + [Formulario hibrido](#formhidrido)
    + [Obtener Credenciales](#credenciales)
 + [Diagrama de secuencia](#secuencia)
 + [Tablas de referencia](#tablareferencia)		
 + [Tabla de errores](#codigoerrores)		 

<a name="instalacion"></a>		
## Instalación		
Se debe descargar la última versión del SDK desde el botón Download ZIP del branch master.
Se debe crear un archivo .gem que debe ser instalado para poder utilizarlo.

<a name="creategem"></a>   
### 1. Creación de la gema TodoPagoConector
Abrir la consola tipear:
```
	cd "ruta-del-sdk"
```
Donde ruta-del-sdk es la ruta donde se descomprimió el zip

Para crear el archivo .gem se debe ejecutar el comando gem build
```
        gem build TodoPagoConector.gemspec
```

Se debe obtener el archivo TodoPagoConector.gem
[<sub>Volver a inicio</sub>](#inicio)	

<a name="installgem"></a>   
#### 2. Instalación de la gema TodoPagoConector
```
        gem install ./TodoPagoConector.gem
        gem install json
```
[<sub>Volver a inicio</sub>](#inicio)	

<a name="Versionesdephpsoportadas"></a> 

#### 3. Versiones de Ruby soportadas    
La versión implementada de la SDK, esta testeada para versiones de Ruby desde 1.9.3 en adelante.
[<sub>Volver a inicio</sub>](#inicio)

<a name="general"></a>
#### 4. Generalidades
Esta versión soporta únicamente pago en moneda nacional argentina (CURRENCYCODE = 32).

[<sub>Volver a inicio</sub>](#inicio)	
<br>
<a name="uso"></a>		
## Uso		

<a name="initconector"></a>
####Inicializar la clase correspondiente al conector (TodoPagoConector).

- crear una estrucura como la del ejemplo con las wsdl suministradas por Todo Pago

```ruby
j_wsdls = {
    #Remoto
    'Authorize'=> 'https://developers.todopago.com.ar/services/t/1.1/Authorize?wsdl'
    #Local
    #'Authorize'=> '../lib/Authorize.wsdl'
    }
```
- crear una estructura como la del ejemplo con los http header suministrados por todo pago
```ruby
j_header_http = {
    "Authorization"=>"PRISMA f3d8b72c94ab4a06be2ef7c95490f7d3"
}
```
- crear una instancia de la clase TodoPago

```ruby		
end_point = 'https://developers.todopago.com.ar/'

conector = TodoPagoConector.new(j_header_http,
                                j_wsdls,
                                end_point) # End Point, wsdl y http_header provisto por TODO PAGO   
```				

<a name="solicitudautorizacion"></a>
####Solicitud de autorización		
En este caso hay que llamar a sendAuthorizeRequest(). 		
```ruby		
response = conector.sendAuthorizeRequest(optionsSAR_comercio,optionsSAR_operacion)
```				
<ins><strong>Datos propios del comercio</strong></ins>		
optionsSAR_comercio debe ser un Hash con la siguiente estructura:		
<a name="url_ok"></a>
<a name="url_error"></a>
```ruby
optionsSAR_comercio = Hash.new
optionsSAR_comercio[:Security]="f3d8b72c94ab4a06be2ef7c95490f7d3"
optionsSAR_comercio[:Merchant]= "2153"
optionsSAR_comercio[:EncodingMethod]="XML"
optionsSAR_comercio[:URL_OK]="http://someurl.com/ok/"
optionsSAR_comercio[:URL_ERROR]="http://someurl.com/error/"
optionsSAR_comercio[:Session]= "ABCDEF-1234-12221-FDE1-00000200"
```		

<ins><strong>Datos propios de la operación</strong></ins>		
optionsSAR_operacion debe ser un Hash con la siguiente estructura:		
		
```ruby
optionsSAR_operacion = Hash.new
optionsSAR_operacion[:MERCHANT] = "2153"
optionsSAR_operacion[:OPERATIONID] = "8000"
optionsSAR_operacion[:CURRENCYCODE] = "032"
optionsSAR_operacion[:AMOUNT] = "1.00"
```

La variable response contendrá una estuctura en la cual **url_request** es donde está hosteado el formulario de pago y donde hay que redireccionar al usuario, una vez realizado el pago según el éxito o fracaso del mismo, el formulario redireccionará a una de las 2 URLs seteadas en **optionsSAR_comercio** ([URL_OK](#url_ok), en caso de éxito o [URL_ERROR](#url_error), en caso de que por algún motivo el formulario rechace el pago)

<a name="confirmatransaccion"></a>
####Confirmación de transacción.		
En este caso hay que llamar a **getAuthorizeAnswer()**, enviando como parámetro un Hash como se describe a continuación.		
```ruby
optionsAnwser=Hash.new
optionsAnwser[:Security]= "f3d8b72c94ab4a06be2ef7c95490f7d3" #Token de seguridad, provisto por TODO PAGO. MANDATORIO.
optionsAnwser[:MERCHANT]= "2153"
optionsAnwser[:RequestKey]= "710268a7-7688-c8bf-68c9-430107e6b9da" #Valor retornado en el SendAuthorizeRequest
optionsAnwser[:AnswerKey]= "693ca9cc-c940-06a4-8d96-1ab0d66f3ee6"  #Valor que figura en la URL del redirect luego de realizar el pago

response = conector.getAuthorizeAnswer(optionsAnwser)
```		

Se deben guardar y recuperar los valores de los campos <strong>RequestKey</strong> y <strong>AnswerKey</strong>.

El parámetro <strong>RequestKey</strong> es siempre distinto y debe ser persistido de alguna forma cuando el comprador es redirigido al formulario de pagos.

<ins><strong>Importante</strong></ins> El campo **AnswerKey** se adiciona  en la redirección que se realiza a alguna de las direcciones ( URL ) epecificadas en el  servicio **SendAurhorizationRequest**, esto sucede cuando la transacción ya fue resuelta y es necesario regresar al site para finalizar la transacción de pago.		

<a name="ejemplo"></a>      
####Ejemplo
Existe un ejemplo en la carpeta https://github.com/TodoPago/sdk-ruby/blob/master/TodoPago/test.rb el cual tiene configurados estos valores, y muestra los resultados de los métodos principales del SDK.
[<sub>Volver a inicio</sub>](#inicio)

<a name="test"></a>      
####Modo Test

El SDK-RUBY permite trabajar con los ambiente de desarrollo y de produccion de Todo Pago.<br>

Para utlilizar el modo test se debe pasar un end point de prueba (provisto por TODO PAGO).
```ruby
conector_test = TodoPagoConector.new(j_header_http_test, j_wsdls_test, end_point_test)
 ```

[<sub>Volver a inicio</sub>](#inicio)
<br>

<a name="datosadicionales"></a>		
## Datos adicionales para control de fraude		
Los datos adicionales para control de fraude son **obligatorios**, de lo contrario baja el score de la transacción.

Los campos marcados como **condicionales** afectan al score negativamente si no son enviados, pero no son mandatorios o bloqueantes.

```ruby		
optionsSAR_operacion=Hash.new 		
...........................................................................		
optionsSAR_operacion[:CSBTCITY] = "Villa General Belgrano" #Ciudad de facturación, MANDATORIO.		
optionsSAR_operacion[:CSBTCOUNTR]="AR" #País de facturación. MANDATORIO. Código ISO. (http://apps.cybersource.com/library/documentation/sbc/quickref/countries_alpha_list.pdf)		
optionsSAR_operacion[:CSBTCUSTOMERID]="453458" #Identificador del usuario al que se le emite la factura. MANDATORIO. No puede contener un correo electrónico.		
optionsSAR_operacion[:CSBTIPADDRESS]="192.0.0.4" #IP de la PC del comprador. MANDATORIO.		
optionsSAR_operacion[:CSBTEMAIL]="some@someurl.com" #Mail del usuario al que se le emite la factura. MANDATORIO.	
optionsSAR_operacion[:CSBTFIRSTNAME]="Juan" #Nombre del usuario al que se le emite la factura. MANDATORIO.		
optionsSAR_operacion[:CSBTLASTNAME]="Perez" #Apellido del usuario al que se le emite la factura. MANDATORIO.		
optionsSAR_operacion[:CSBTPHONENUMBER]="541160913988" #Teléfono del usuario al que se le emite la factura. No utilizar guiones, puntos o espacios. Incluir código de país. MANDATORIO.		
optionsSAR_operacion[:CSBTPOSTALCODE]="1010" #Código Postal de la dirección de facturación. MANDATORIO.		
optionsSAR_operacion[:CSBTSTATE]="B" #Provincia de la dirección de facturación. MANDATORIO. Ver tabla anexa de provincias.
optionsSAR_operacion[:CSBTSTREET1]="Some Street 2153" #Domicilio de facturación (calle y nro). MANDATORIO.		
optionsSAR_operacion[:CSBTSTREET2]="" #Complemento del domicilio. (piso, departamento). NO MANDATORIO.		
optionsSAR_operacion[:CSPTCURRENCY]="ARS" #Moneda. MANDATORIO.		
optionsSAR_operacion[:CSPTGRANDTOTALAMOUNT]="10.01" #Con decimales opcional usando el puntos como separador de decimales. No se permiten comas, ni como separador de miles ni como separador de decimales. MANDATORIO. (Ejemplos:$125,38-> 125.38 $12-> 12 o 12.00)
optionsSAR_operacion[:CSMDD7]="" # Fecha registro comprador(num Dias). NO MANDATORIO.		
optionsSAR_operacion[:CSMDD8]="" #Usuario Guest? (Y/N). En caso de ser Y, el campo CSMDD9 no deberá enviarse. NO MANDATORIO.
optionsSAR_operacion[:CSMDD9]="" #Customer password Hash: criptograma asociado al password del comprador final. NO MANDATORIO.	
optionsSAR_operacion[:CSMDD10]="" #Histórica de compras del comprador (Num transacciones). NO MANDATORIO.		
optionsSAR_operacion[:CSMDD11]="" #Customer Cell Phone. NO MANDATORIO.		

#Retail
optionsSAR_operacion[:CSSTCITY]="Villa General Belgrano" #Ciudad de enví­o de la orden. MANDATORIO.		
optionsSAR_operacion[:CSSTCOUNTRY]="" #País de envío de la orden. MANDATORIO.		
optionsSAR_operacion[:CSSTEMAIL]="some@someurl.com" #Mail del destinatario, MANDATORIO.		
optionsSAR_operacion[:CSSTFIRSTNAME]="Jose" #Nombre del destinatario. MANDATORIO.		
optionsSAR_operacion[:CSSTLASTNAME]="Perez" #Apellido del destinatario. MANDATORIO.		
optionsSAR_operacion[:CSSTPHONENUMBER]="541160913988" #Número de teléfono del destinatario. MANDATORIO.		
optionsSAR_operacion[:CSSTPOSTALCODE]="1010" #Código postal del domicilio de envío. MANDATORIO.		
optionsSAR_operacion[:CSSTSTATE]="D" #Provincia de envío. MANDATORIO. Son de 1 caracter		
optionsSAR_operacion[:CSSTSTREET1]="Some Street 2153" #Domicilio de envío. MANDATORIO.		
optionsSAR_operacion[:CSMDD12]="" #Shipping DeadLine (Num Dias). NO MADATORIO.		
optionsSAR_operacion[:CSMDD13]="" #Método de Despacho. NO MANDATORIO.		
optionsSAR_operacion[:CSMDD14]="" #Customer requires Tax Bill ? (Y/N). NO MANDATORIO.		
optionsSAR_operacion[:CSMDD15]="" #Customer Loyality Number. NO MANDATORIO. 		
optionsSAR_operacion[:CSMDD16]="" #Promotional / Coupon Code. NO MANDATORIO. 

#Datos a enviar por cada producto, los valores deben estar separado con #.		
optionsSAR_operacion[:CSITPRODUCTCODE]="electronic_good" #Código de producto. CONDICIONAL. Valores posibles(adult_content;coupon;default;electronic_good;electronic_software;gift_certificate;handling_only;service;shipping_and_handling;shipping_only;subscription)		
optionsSAR_operacion[:CSITPRODUCTDESCRIPTION]="Test Prd Description" #Descripción del producto. CONDICIONAL.
optionsSAR_operacion[:CSITPRODUCTNAME]="TestPrd" #Nombre del producto. CONDICIONAL.		
optionsSAR_operacion[:CSITPRODUCTSKU]="SKU1234" #Código identificador del producto. CONDICIONAL.		
optionsSAR_operacion[:CSITTOTALAMOUNT]="10.01" #CSITTOTALAMOUNT=CSITUNITPRICE*CSITQUANTITY "999999[.CC]" Con decimales opcional usando el puntos como separador de decimales. No se permiten comas, ni como separador de miles ni como separador de decimales. CONDICIONAL.		
optionsSAR_operacion[:CSITQUANTITY]="1" #Cantidad del producto. CONDICIONAL.		
optionsSAR_operacion[:CSITUNITPRICE]="10.01" #Formato Idem CSITTOTALAMOUNT. CONDICIONAL.		
...........................................................		
```
<a name="datosreferencia"></a>    
#### Datos de referencia   

<table style="max-width:200px;">
<tr><th>Nombre del campo</th><th>Required/Optional</th><th>Mínimo</th><th>Data Type</th><th>Comentarios</th></tr>
<tr><td style="max-width:200px;">CSBTCITY</td><td>Required</td><td>String (50)</td><td>1</td><td>Ciudad / Debe comenzar con una letra</td></tr>
<tr><td>CSBTCOUNTRY</td><td>Required</td><td>String (2)</td><td>1</td><td>Código <a href="http://apps.cybersource.com/library/documentation/sbc/quickref/countries_alpha_list.pdf">ISO</a></td></tr>
<tr><td> CSBTCUSTOMERID</td><td>Required</td><td>String (50)</td><td>1</td><td>Identificador del usuario unico logueado al portal (No puede ser una direccion de email)</td></tr><td>
<tr><td> CSBTEMAIL</td><td>Required</td><td>String (100)</td><td>1</td><td>correo electronico del comprador</td></tr>
<tr><td>CSBTFIRSTNAME</td><td>Required</td><td>String (60)</td><td>1</td><td>Nombre del tarjeta habiente / Sin caracteres especiales como acentos invertidos, sólo letras, números y espacios</td></tr>
<tr><td>CSBTIPADDRESS</td><td>Required</td><td>String (15)</td><td>1</td><td>"End Customer´s IP address, such as 10.1.27.63, reported by your Web server via socket information."</td></tr>
<tr><td> CSBTLASTNAME</td><td>Required</td><td>String (60)</td><td>1</td><td>Apellido del tarjetahabiente / Sin caracteres especiales como acentos invertidos, sólo letras, números y espacios</td></tr> <td>
<tr><td>CSBTPHONENUMBER</td><td>Required</td><td>String (15)</td><td>6</td><td>Número de telefono</td></tr>
<tr><td>CSBTPOSTALCODE</td><td>Required</td><td>String (10)</td><td>1</td><td>Codigo Postal</td></tr> 
<tr><td>CSBTSTATE</td><td>Required</td><td>String (2)</td><td>1</td><td>Estado (Si el country = US, el campo se valida para un estado valido en USA)</td></tr>
<tr><td>CSBTSTREET1</td><td>Required</td><td>String (60)</td><td>1</td><td>Calle Numero interior Numero Exterior</td></tr> 
<tr><td>CSBTSTREET2</td><td>Optional</td><td>String (60)</td><td></td><td>Barrio</td></tr>
<tr><td>CSITPRODUCTCODE</td><td>Conditional</td><td>String (255)</td><td></td><td></td> </tr>
<tr><td>CSITPRODUCTDESCRIPTION</td><td>Conditional</td><td>String (255)</td><td></td><td>Descripción general del producto</td></tr> 
<tr><td>CSITPRODUCTNAME</td><td>Conditional</td><td>String (255)</td><td></td><td>Nombre en catalogo del producto</td></tr>
<tr><td>CSITPRODUCTSKU</td><td>Conditional</td><td>String (255)</td><td></td><td>SKU en catalogo</td></tr> 
<tr><td>CSITQUANTITY</td><td>Conditional</td><td>Integer (10)</td><td></td><td>Cantidad productos del mismo tipo agregados al carrito</td></tr> 
<tr><td>CSITTOTALAMOUNT</td><td>Conditional</td><td></td><td></td><td>"Precio total = Precio unitario * quantity / CSITTOTALAMOUNT = CSITUNITPRICE * CSITQUANTITY ""999999.CC"" Es mandatorio informar los decimales, usando el punto como separador de decimales. No se permiten comas, ni como separador de miles ni como separador de decimales."</td></tr>
<tr><td>CSITUNITPRICE</td><td>Conditional</td><td>String (15)</td><td></td><td>"Precio Unitaro del producto / ""999999.CC"" Es mandatorio informar los decimales, usando el punto como separador de decimales. No se permiten comas, ni como separador de miles ni como separador de decimales."</td></tr> 
<tr><td>CSPTCURRENCY</td><td>Required</td><td>String (5)</td><td>1</td><td><a href="http://apps.cybersource.com/library/documentation/sbc/quickref/currencies.pdf">Currencies</a></td></tr> 
<tr><td>CSPTGRANDTOTALAMOUNT</td><td>Required</td><td>Decimal (15)</td><td>1</td><td>"Cantidad total de la transaccion./""999999.CC"" Con decimales obligatorios, usando el puntos como separador de decimales. No se permiten comas, ni como separador de miles ni como separador de decimales."</td></tr> 
<tr><td>CSSTCITY</td><td>Required</td><td>String (50)</td><td>1</td><td>Ciudad / Debe comenzar con una letra</td>
<tr><td> CSSTCOUNTRY</td><td>Required</td><td>String (2)</td><td>1</td><td><a href="http://apps.cybersource.com/library/documentation/sbc/quickref/countries_alpha_list.pdf">Código ISO</a></td></tr>
<tr><td>CSSTEMAIL</td><td>Required</td><td>String (100)</td><td>1</td><td>correo electrónico del comprador</td></tr> 
<tr><td>CSSTFIRSTNAME</td><td>Required</td><td>String (60)</td><td>1</td><td>Nombre del tarjeta habiente / Sin caracteres especiales como acentos invertidos, sólo letras, números y espacios</td></tr> 
<tr><td>CSSTLASTNAME</td><td>Required</td><td>String (60)</td><td>1</td><td>Apellido del tarjetahabiente / Sin caracteres especiales como acentos invertidos, sólo letras, números y espacios</td></tr> 
<tr><td>CSSTPHONENUMBER</td><td>Required</td><td>String (15)</td><td>6</td><td>"Número de telefono. Cuidar el hecho que por default algunos comercios envían ""54"", contando entonces con 2 de los 6 caracteres requeridos."</td></tr> 
<tr><td>CSSTPOSTALCODE</td><td>Required</td><td>String (10)</td><td>1</td><td>Código Postal</td></tr>
<tr><td>CSSTSTATE</td><td>Required</td><td>String (2)</td><td>1</td><td>Estado (Si el country = US, el campo se valida para un estado v lido en USA)</td><tr> 
<tr><td>CSSTSTREET1</td><td>Required</td><td>String (60)</td><td>1</td><td>Calle Numero interior Numero Exterior / Para los casos que no son de envío a domicilio, jam s enviar la dirección propia del comercio o correo donde se retire la mercadería, en ese caso replicar los datos de facturación.</td></tr>
<tr><td> CSSTSTREET2</td><td>Optional</td><td>String (60)</td><td></td><td>Barrio</td></tr> 
<tr><td>CSMDD1 </td><td>Required</td><td>String (255)</td><td>1</td><td>Incluir numero de comercio proveniente del campo NROCOMERCIO del API DECIDIR</td></tr> 
<tr><td>CSMDD2</td><td>Required</td><td>String (255)</td><td>1</td><td>Incluir el nombre del comercio, Decidir puede obtener este dato del portal de configuracion de comercios</td></tr>
<tr><td> CSMDD3</td><td>Required (Catalogo)</td><td>String (255)</td><td>1</td><td>"Valores ejemplo: (retail, digital goods, services, travel, ticketing) Es recomendable que el API de decidir fije opciones seleccionables y no sean de captura libre para el comercio"</td></tr> 
<tr><td>CSMDD4</td><td>Optional (Catalogo)</td><td>String (255)</td><td></td><td>"Valores ejemplo: (Visa, Master Card, Tarjeta Shopping, Banelco...) Es recomendable que el API de decidir fije opciones seleccionables y no sean de captura libre para el comercio. Se tienen que incluir todos los medios de pago aceptados"</td></tr>
<tr><td> CSMDD5</td><td>Optional</td><td>String (255)</td><td></td><td>Valor numerico que detalle el numero de cuotas</td></tr>
<tr><td>CSMDD6</td><td>Optional (Catalogo)</td><td>String (255)</td><td></td><td>"Valores ejemplo: (Web, Call Center, Mobile, Kiosko) Es recomendable que el API de decidir fije opciones seleccionables y no sean de captura libre para el comercio."</td></tr> 
<tr><td>CSMDD7</td><td>Optional</td><td>String (255)</td><td></td><td>Numero de dias que tiene registrado un cliente en el portal del comercio.</td></tr>
<tr><td>CSMDD8</td><td>Optional</td><td>String (255)</td><td></td><td>Valor Boleano para indicar si el usuario esta comprando como invitado en la pagina del comercio. Valores posibles (S/N)</td></tr> 
<tr><td>CSMDD9</td><td>Optional</td><td>String (255)</td><td></td><td>Valor del password del usuario registrado en el portal del comercio. Incluir el valor en hash</td></tr> 
<tr><td>CSMDD10</td><td>Optional</td><td>String (255)</td><td></td><td>Conteo de transacciones realizadas por el mismo usuario registrado en el portal del comercio</td></tr>
<tr><td>CSMDD11</td><td>Optional</td><td>String (255)</td><td></td><td>Incluir numero de telefono adicional del comprador</td></tr> 
<tr><td>CSMDD12</td><td>Optional</td><td>String (255)</td><td></td><td>Numero de dias que tiene el comercio para hacer la entrega</td></tr> 
<tr><td>CSMDD13</td><td>Optional (Catalogo)</td><td>String (255)</td><td></td><td>"Valores ejemplo: (domicilio, click and collect, carrier) Es recomendable que el API de decidir fije opciones seleccionables y no sean de captura libre para el comercio."</td></tr> 
<tr><td>CSMDD14</td><td>Optional</td><td>String (255)</td><td></td><td>Valor booleano para identificar si el cliente requiere un comprobante fiscal o no S / N</td></tr>
<tr><td>CSMDD15</td><td>Optional</td><td>String (255)</td><td></td><td>Incluir numero de cliente frecuente</td></tr>
<tr><td>CSMDD16</td><td>Optional</td><td>String (255)</td><td></td><td>Incluir numero de cupon de descuento</td></tr>
<tr><td>CSMDD35</td><td>Conditional (Transaccion con Visa)</td><td>String (255)</td><td></td><td>Tipo de documento solicitado por el comercio al cliente</td></tr>
<tr><td>CSMDD36</td><td>Conditional (Transaccion con Visa)</td><td>String (255)</td><td></td><td>Numero de documento solicitado por el comercio al cliente</td></tr>
<tr><td>CSMDD37</td><td>Conditional (Transaccion con Visa)</td><td>String (255)</td><td></td><td>Numero de puerta</td></tr>
<tr><td> CSMDD38</td><td>onditional (Transaccion con Visa)</td><td>String (255)</td><td></td><td>Fecha de nacimiento del comprador, dato solicitado por el comercio. DECIDIR tiene el formato exacto de como se debe de capturar</td></tr>
<tr><td>CSMDD39</td><td>Conditional (Transaccion con Visa)</td><td>String (255)</td><td></td><td>Valor numero correspondiente a la validacion de cada uno de los datos anteriores ejemplo: 1012</td></tr>
<tr><td> CSMDD40</td><td>Optional</td><td>String(1)</td><td></td><td>"Valor para identificar si la transaccion ha sido reportada como fraude por parte del emisor. Incluir el parametro con valor = S Este parametro lo genera decidir a partir de la respuesta del emisor. En caso de una transaccion aceptada por el emisor o con rechazo diferente a fraude, NO INCLUIR"</td></tr> 
<tr><td>CSMDD41</td><td>Optional</td><td>String(1)</td><td></td><td>Datos proporcionado por DECIDIR en el form. De pago. Valores posibles S/N</td></tr> 
<tr><td>CSMDD42</td><td>Optional</td><td>String(1)</td><td></td><td>Datos proporcionado por DECIDIR en el form. De pago. Valores posibles S/N</td></tr>
<tr><td>CSMDD80</td><td>Required </td><td>Integer (20)</td><td></td><td>Número de cuenta del vendedor</td></tr>
<tr><td> CSMDD81</td><td>Required </td><td>String(255)</td><td></td><td>Mail del vendedor en TP</td></tr>
<tr><td> CSMDD82</td><td>Required </td><td>Integer (6)</td><td></td><td>Rubro asignado por el analista de riesgos de Back Office</td></tr>
<tr><td>CSMDD83</td><td>Required </td><td>Integer (2)</td><td></td><td>Antig�edad de la cuenta vendedor</td></tr> 
<tr><td>CSMDD84</td><td>Required </td><td>String (15)</td><td></td><td>Consumidor Final / Profesional / Empresa</td></tr> 
<tr><td>CSMDD85</td><td>Required </td><td>Integer(1)</td><td></td><td>0 (No se le pidió) / 1 (Se le pidió y se validó) / 2 (Uso Futuro)</td></tr>
<tr><td> CSMDD86</td><td>Requerido (para Billetera)</td><td>Integer(20)</td><td></td><td>Número de cuenta del comprador</td></tr>
<tr><td>CSMDD87</td><td>Requerido (para Billetera)</td><td>Integer (3)</td><td></td><td>Antig�edad de la cuenta comprador (Meses)</td></tr> 
<tr><td>CSMDD88</td><td>Requerido (para Billetera)</td><td>Integer (3)</td><td></td><td>Cantidad de tarjetas Habilitadas de la Billetera</td></tr> 
<tr><td>CSMDD89</td><td>Requerido (para Billetera)</td><td>Integer (2)</td><td></td><td>Nivel de Riesgo asignado al Medio de Pago que Utiliza</td></tr>
</table>

[<sub>Volver a inicio</sub>](#inicio)
<br>

<a name="caracteristicas"></a>
## Características

<a name="status"></a>
####Status de la Operación
La SDK cuenta con un método para consultar el status de la transacción desde la misma SDK. El método se utiliza de la siguiente manera:
```ruby
optionsOperations=Hash.new
optionsOperations[:MERCHANT]= merchant #merchant es una variable 
optionsOperations[:OPERATIONID]= operationid #operationid es una variable (id de la opereacion)
conector.getOperations(optionsOperations)
```

Además, se puede conocer el estado de las transacciones a través del portal [www.todopago.com.ar](http://www.todopago.com.ar/). Desde el portal se verán los estados "Aprobada" y "Rechazada". Si el método de pago elegido por el comprador fue Pago Fácil o RapiPago, se podrán ver en estado "Pendiente" hasta que el mismo sea pagado.
	
<a name="statusdate"></a>
####Consulta de operaciones por rango de tiempo
En este caso hay que llamar a **getByRangeDateTime()** y devolvera todas las operaciones realizadas en el rango de fechas dado

```ruby
optionsGBRDT=Hash.new
optionsGBRDT[:Merchant]= "2866"
optionsGBRDT[:STARTDATE]= "2016-01-01"
optionsGBRDT[:ENDDATE]= "2016-02-19"
optionsGBRDT[:PAGENUMBER] = "1"

response = tpc.getByRangeDateTime(optionsGBRDT)
```	

<a name="devolucion"></a>
####Devolución

La SDK dispone de métodos para realizar la devolución, de una transacción realizada a traves de TodoPago.

Se debe llamar al método ```voidRequest``` de la siguiente manera:
```ruby

options = Hash.new

options[:Security] = "837BE68A892F06C17B944F344AEE8F5F", #API Key del comercio asignada por TodoPago 
options[:Merchant] = "35", #Merchant o Nro de comercio asignado por TodoPago
options[:RequestKey] = "6d2589f2-37e6-1334-7565-3dc19404480c" #RequestKey devuelto como respuesta del servicio SendAutorizeRequest

resp = tpc.voidRequest(options)	
```

También se puede llamar al método ```voidRequest``` de la esta otra manera:
```ruby

options[:Security] = "837BE68A892F06C17B944F344AEE8F5F", #API Key del comercio asignada por TodoPago 
options[:Merchant] = "35", #Merchant o Nro de comercio asignado por TodoPago
options[:AuthorizationKey] = "6d2589f2-37e6-1334-7565-3dc19404480c" #AuthorizationKey devuelto como respuesta del servicio GetAuthorizeAnswer

resp = tpc.voidRequest(options)	
```

**Respuesta del servicio:**
Si la operación fue realizada correctamente se informará con un código 2011 y un mensaje indicando el éxito de la operación.

``` ruby
{:envelope=>{:body=>{:return_response=>{:status_code=>"2011", :status_message=>"TX OK", :authorization_key=>"318974f2-4866-d8e7-9622-9ac21aec0df2", :authorizationcode=>"2011", :"@xmlns:api"=>"http://api.todopago.com.ar"}}, :"@xmlns:soapenv"=>"http://schemas.xmlsoap.org/soap/envelope/"}}
```
<br>

<a name="devolucionparcial"></a>
####Devolución parcial

La SDK dispone de métodos para realizar la devolución parcial, de una transacción realizada a traves de TodoPago.

Se debe llamar al método ```returnRequest``` de la siguiente manera:
```ruby

options = Hash.new

options[:Security]= "837BE68A892F06C17B944F344AEE8F5F", #API Key del comercio asignada por TodoPago 
options[:Merchant] ="35", #Merchant o Nro de comercio asignado por TodoPago
options[:RequestKey] = "6d2589f2-37e6-1334-7565-3dc19404480c" #RequestKey devuelto como respuesta del servicio SendAutorizeRequest
options[:AMOUNT] = "23.50" #Opcional. Monto a devolver, si no se envía, se trata de una devolución total

resp = tpc.returnRequest(options)
```

También se puede llamar al método ```returnRequest``` de la esta otra manera:
```ruby
options = Hash.new

options[:Security] = "837BE68A892F06C17B944F344AEE8F5F", #API Key del comercio asignada por TodoPago 
options[:Merchant] = "35", #Merchant o Nro de comercio asignado por TodoPago
options[:AuthorizationKey] = "6d2589f2-37e6-1334-7565-3dc19404480c" #AuthorizationKey devuelto como respuesta del servicio GetAuthorizeAnswer
options[:AMOUNT] = "1.00" #Opcional. Monto a devolver, si no se envía, se trata de una devolución total

resp = tpc.returnRequest(options)	
```

**Respuesta de servicio:**
Si la operación fue realizada correctamente se informará con un código 2011 y un mensaje indicando el éxito de la operación.

``` ruby
{:envelope=>{:body=>{:return_response=>{:status_code=>"2011", :status_message=>"TX OK", :authorization_key=>"318974f2-4866-d8e7-9622-9ac21aec0df2", :authorizationcode=>"2011", :"@xmlns:api"=>"http://api.todopago.com.ar"}}, :"@xmlns:soapenv"=>"http://schemas.xmlsoap.org/soap/envelope/"}}
```
<br>
<a name="formhidrido"></a>
####Formulario hibrido

**Conceptos basicos**<br>
El formulario hibrido, es una alternativa al medio de pago actual por redirección al formulario externo de TodoPago.<br> 
Con el mismo, se busca que el comercio pueda adecuar el look and feel del formulario a su propio diseño.

**Libreria**<br>
El formulario requiere incluir en la pagina una libreria Javascript de TodoPago.<br>
El endpoint depende del entorno:
+ Desarrollo: https://developers.todopago.com.ar/resources/TPHybridForm-v0.1.js
+ Produccion: https://forms.todopago.com.ar/resources/TPHybridForm-v0.1.js

**Restricciones y libertades en la implementación**

+ Ninguno de los campos del formulario podrá contar con el atributo name.
+ Se deberá proveer de manera obligatoria un botón para gestionar el pago con Billetera Todo Pago.
+ Todos los elementos de tipo <option> son completados por la API de Todo Pago.
+ Los campos tienen un id por defecto. Si se prefiere utilizar otros ids se deberán especificar los
mismos cuando se inicialice el script de Todo Pago.
+ Pueden aplicarse todos los detalles visuales que se crean necesarios, la API de Todo Pago no
altera los atributos class y style.
+ Puede utilizarse la API para setear los atributos placeholder del formulario, para ello deberá
especificar dichos placeholders en la inicialización del formulario "window.TPFORMAPI.hybridForm.setItem". En caso de que no se especifiquen los placeholders se usarán los valores por defecto de la API.

**HTML del formulario**

El formulario implementado debe contar al menos con los siguientes campos.

```html
<body>
	<select id="formaDePagoCbx"></select>
	<select id="bancoCbx"></select>
	<select id="promosCbx"></select>
	<label id="labelPromotionTextId"></label>
	<input id="numeroTarjetaTxt"/>
	<input id="mesTxt"/>
	<input id="anioTxt"/>
	<input id="codigoSeguridadTxt"/>
	<label id="labelCodSegTextId"></label>
	<input id="apynTxt"/>
	<select id="tipoDocCbx"></select>
	<input id="nroDocTxt"/>
	<input id="emailTxt"/><br/>
	<button id="MY_btnConfirmarPago"/>
</body>
```

**Inizialización y parametros requeridos**<br>
Para inicializar el formulario se usa window.TPFORMAPI.hybridForm.initForm. El cual permite setear los elementos y ids requeridos.

Para inicializar un ítem de pago, es necesario llamar a window.TPFORMAPI.hybridForm.setItem. Este requiere obligatoriamente el parametro publicKey que corresponde al PublicRequestKey (entregado por el SAR).
Se sugiere agregar los parametros usuario, e-mail, tipo de documento y numero.

**Javascript**
```js
window.TPFORMAPI.hybridForm.initForm({
    callbackValidationErrorFunction: 'validationCollector',
	callbackCustomSuccessFunction: 'customPaymentSuccessResponse',
	callbackCustomErrorFunction: 'customPaymentErrorResponse',
	botonPagarId: 'MY_btnConfirmarPago',
	modalCssClass: 'modal-class',
	modalContentCssClass: 'modal-content',
	beforeRequest: 'initLoading',
	afterRequest: 'stopLoading'
});

window.TPFORMAPI.hybridForm.setItem({
    publicKey: 'taf08222e-7b32-63d4-d0a6-5cabedrb5782', //obligatorio
    defaultNombreApellido: 'Usuario',
    defaultNumeroDoc: 20234211,
    defaultMail: 'todopago@mail.com',
    defaultTipoDoc: 'DNI'
});

//callbacks de respuesta del pago
function validationCollector(parametros) {
}
function customPaymentSuccessResponse(response) {
}
function customPaymentErrorResponse(response) {
}
function initLoading() {
}
function stopLoading() {
}
```

**Callbacks**<br>
El formulario define callbacks javascript, que son llamados según el estado y la informacion del pago realizado:
+ customPaymentSuccessResponse: Devuelve response si el pago se realizo correctamente.
+ customPaymentErrorResponse: Si hubo algun error durante el proceso de pago, este devuelve el response con el codigo y mensaje correspondiente.

[<sub>Volver a inicio</sub>](#inicio)

<a name="credenciales"></a>
####Obtener credenciales
El SDK permite obtener las credenciales "Authentification", "MerchandId" y "Security" de la cuenta de Todo Pago, ingresando el usuario y contraseña.<br>
Esta funcionalidad es util para obtener los parametros de configuracion dentro de la implementacion.
	
- Crear una instancia de la clase User:
```ruby
u = User.new("email@ejemplo.com", "password1")
response = conector.getCredentials(u)
```

**Observación**: El Security se obtiene a partir de apiKey, eliminando TODOPAGO de este ultimo.

[<sub>Volver a inicio</sub>](#inicio)
<br>

<a name="secuencia"></a>
##Diagrama de secuencia
![imagen de configuracion](https://raw.githubusercontent.com/TodoPago/imagenes/master/README.img/secuencia-page-001.jpg)

[<sub>Volver a inicio</sub>](#inicio)
<br>

<a name="tablareferencia"></a>    
## Tablas de Referencia   
######[Provincias](#p)    
				
<p>Solo utilizado para incluir los datos de control de fraude</p>
<table>		
<tr><th>Provincia</th><th>Código</th></tr>		
<tr><td>CABA</td><td>C</td></tr>		
<tr><td>Buenos Aires</td><td>B</td></tr>		
<tr><td>Catamarca</td><td>K</td></tr>		
<tr><td>Chaco</td><td>H</td></tr>		
<tr><td>Chubut</td><td>U</td></tr>		
<tr><td>Córdoba</td><td>X</td></tr>		
<tr><td>Corrientes</td><td>W</td></tr>		
<tr><td>Entre Ríos</td><td>E</td></tr>		
<tr><td>Formosa</td><td>P</td></tr>		
<tr><td>Jujuy</td><td>Y</td></tr>		
<tr><td>La Pampa</td><td>L</td></tr>		
<tr><td>La Rioja</td><td>F</td></tr>		
<tr><td>Mendoza</td><td>M</td></tr>		
<tr><td>Misiones</td><td>N</td></tr>		
<tr><td>Neuquén</td><td>Q</td></tr>		
<tr><td>Río Negro</td><td>R</td></tr>		
<tr><td>Salta</td><td>A</td></tr>		
<tr><td>San Juan</td><td>J</td></tr>		
<tr><td>San Luis</td><td>D</td></tr>		
<tr><td>Santa Cruz</td><td>Z</td></tr>		
<tr><td>Santa Fe</td><td>S</td></tr>		
<tr><td>Santiago del Estero</td><td>G</td></tr>		
<tr><td>Tierra del Fuego</td><td>V</td></tr>		
<tr><td>Tucumán</td><td>T</td></tr>		
</table>

[<sub>Volver a inicio</sub>](#inicio)

<a name="codigoerrores"></a>    
## Tabla de errores     

<table>		
<tr><th>Id mensaje</th><th>Mensaje</th></tr>				
<tr><td>-1</td><td>Aprobada.</td></tr>
<tr><td>1081</td><td>Tu saldo es insuficiente para realizar la transacción.</td></tr>
<tr><td>1100</td><td>El monto ingresado es menor al mínimo permitido</td></tr>
<tr><td>1101</td><td>El monto ingresado supera el máximo permitido.</td></tr>
<tr><td>1102</td><td>La tarjeta ingresada no corresponde al Banco indicado. Revisalo.</td></tr>
<tr><td>1104</td><td>El precio ingresado supera al máximo permitido.</td></tr>
<tr><td>1105</td><td>El precio ingresado es menor al mínimo permitido.</td></tr>
<tr><td>2010</td><td>En este momento la operación no pudo ser realizada. Por favor intentá más tarde. Volver a Resumen.</td></tr>
<tr><td>2031</td><td>En este momento la validación no pudo ser realizada, por favor intentá más tarde.</td></tr>
<tr><td>2050</td><td>Lo sentimos, el botón de pago ya no está disponible. Comunicate con tu vendedor.</td></tr>
<tr><td>2051</td><td>La operación no pudo ser procesada. Por favor, comunicate con tu vendedor.</td></tr>
<tr><td>2052</td><td>La operación no pudo ser procesada. Por favor, comunicate con tu vendedor.</td></tr>
<tr><td>2053</td><td>La operación no pudo ser procesada. Por favor, intentá más tarde. Si el problema persiste comunicate con tu vendedor</td></tr>
<tr><td>2054</td><td>Lo sentimos, el producto que querés comprar se encuentra agotado por el momento. Por favor contactate con tu vendedor.</td></tr>
<tr><td>2056</td><td>La operación no pudo ser procesada. Por favor intentá más tarde.</td></tr>
<tr><td>2057</td><td>La operación no pudo ser procesada. Por favor intentá más tarde.</td></tr>
<tr><td>2059</td><td>La operación no pudo ser procesada. Por favor intentá más tarde.</td></tr>
<tr><td>90000</td><td>La cuenta destino de los fondos es inválida. Verificá la información ingresada en Mi Perfil.</td></tr>
<tr><td>90001</td><td>La cuenta ingresada no pertenece al CUIT/ CUIL registrado.</td></tr>
<tr><td>90002</td><td>No pudimos validar tu CUIT/CUIL.  Comunicate con nosotros <a href="#contacto" target="_blank">acá</a> para más información.</td></tr>
<tr><td>99900</td><td>El pago fue realizado exitosamente</td></tr>
<tr><td>99901</td><td>No hemos encontrado tarjetas vinculadas a tu Billetera. Podés  adherir medios de pago desde www.todopago.com.ar</td></tr>
<tr><td>99902</td><td>No se encontro el medio de pago seleccionado</td></tr>
<tr><td>99903</td><td>Lo sentimos, hubo un error al procesar la operación. Por favor reintentá más tarde.</td></tr>
<tr><td>99970</td><td>Lo sentimos, no pudimos procesar la operación. Por favor reintentá más tarde.</td></tr>
<tr><td>99971</td><td>Lo sentimos, no pudimos procesar la operación. Por favor reintentá más tarde.</td></tr>
<tr><td>99977</td><td>Lo sentimos, no pudimos procesar la operación. Por favor reintentá más tarde.</td></tr>
<tr><td>99978</td><td>Lo sentimos, no pudimos procesar la operación. Por favor reintentá más tarde.</td></tr>
<tr><td>99979</td><td>Lo sentimos, el pago no pudo ser procesado.</td></tr>
<tr><td>99980</td><td>Ya realizaste un pago en este sitio por el mismo importe. Si querés realizarlo nuevamente esperá 5 minutos.</td></tr>
<tr><td>99982</td><td>En este momento la operación no puede ser realizada. Por favor intentá más tarde.</td></tr>
<tr><td>99983</td><td>Lo sentimos, el medio de pago no permite la cantidad de cuotas ingresadas. Por favor intentá más tarde.</td></tr>
<tr><td>99984</td><td>Lo sentimos, el medio de pago seleccionado no opera en cuotas.</td></tr>
<tr><td>99985</td><td>Lo sentimos, el pago no pudo ser procesado.</td></tr>
<tr><td>99986</td><td>Lo sentimos, en este momento la operación no puede ser realizada. Por favor intentá más tarde.</td></tr>
<tr><td>99987</td><td>Lo sentimos, en este momento la operación no puede ser realizada. Por favor intentá más tarde.</td></tr>
<tr><td>99988</td><td>Lo sentimos, momentaneamente el medio de pago no se encuentra disponible. Por favor intentá más tarde.</td></tr>
<tr><td>99989</td><td>La tarjeta ingresada no está habilitada. Comunicate con la entidad emisora de la tarjeta para verificar el incoveniente.</td></tr>
<tr><td>99990</td><td>La tarjeta ingresada está vencida. Por favor seleccioná otra tarjeta o actualizá los datos.</td></tr>
<tr><td>99991</td><td>Los datos informados son incorrectos. Por favor ingresalos nuevamente.</td></tr>
<tr><td>99992</td><td>La fecha de vencimiento es incorrecta. Por favor seleccioná otro medio de pago o actualizá los datos.</td></tr>
<tr><td>99993</td><td>La tarjeta ingresada no está vigente. Por favor seleccioná otra tarjeta o actualizá los datos.</td></tr>
<tr><td>99994</td><td>El saldo de tu tarjeta no te permite realizar esta operacion.</td></tr>
<tr><td>99995</td><td>La tarjeta ingresada es invalida. Seleccioná otra tarjeta para realizar el pago.</td></tr>
<tr><td>99996</td><td>La operación fué rechazada por el medio de pago porque el monto ingresado es inválido.</td></tr>
<tr><td>99997</td><td>Lo sentimos, en este momento la operación no puede ser realizada. Por favor intentá más tarde.</td></tr>
<tr><td>99998</td><td>Lo sentimos, la operación fue rechazada. Comunicate con la entidad emisora de la tarjeta para verificar el incoveniente o seleccioná otro medio de pago.</td></tr>
<tr><td>99999</td><td>Lo sentimos, la operación no pudo completarse. Comunicate con la entidad emisora de la tarjeta para verificar el incoveniente o seleccioná otro medio de pago.</td></tr>
</table>

[<sub>Volver a inicio</sub>](#inicio)

