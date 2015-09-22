require "../lib/todo_pago_conector.rb"

j_header_http = {
    'Authorization'=>'PRISMA f3d8b72c94ab4a06be2ef7c95490f7d3', 'Username'=>'>Test'
}

j_wsdls = {
    'Authorize'=> 'https://developers.todopago.com.ar/services/t/1.1/Authorize?wsdl'
    }

endpoint = 'https://developers.todopago.com.ar/'

conector = TodoPagoConector.new(j_header_http,
                                j_wsdls,
                                endpoint)

##############################################Authorize################################################
optionsSAR_operacion = Hash.new
optionsSAR_operacion[:MERCHANT] = "2153"
optionsSAR_operacion[:OPERATIONID] = "70"
optionsSAR_operacion[:CURRENCYCODE] = "032"
optionsSAR_operacion[:AMOUNT] = "50"

#Control de Fraude
optionsSAR_operacion[:CSBTCITY]="Villa General Belgrano"
optionsSAR_operacion[:CSSTCITY]= "Villa General Belgrano"

optionsSAR_operacion[:CSBTCOUNTRY]= "AR"
optionsSAR_operacion[:CSSTCOUNTRY]= "AR"

optionsSAR_operacion[:CSBTEMAIL]= "todopago@hotmail.com"
optionsSAR_operacion[:CSSTEMAIL]= "todopago@hotmail.com"

optionsSAR_operacion[:CSBTFIRSTNAME]= "Juan"
optionsSAR_operacion[:CSSTFIRSTNAME]= "Juan"

optionsSAR_operacion[:CSBTLASTNAME]= "Perez"
optionsSAR_operacion[:CSSTLASTNAME]= "Perez"

optionsSAR_operacion[:CSBTPHONENUMBER]= "541160913988"     
optionsSAR_operacion[:CSSTPHONENUMBER]= "541160913988"     

optionsSAR_operacion[:CSBTPOSTALCODE]= " 1010"
optionsSAR_operacion[:CSSTPOSTALCODE]= " 1010"

optionsSAR_operacion[:CSBTSTATE]= "B"
optionsSAR_operacion[:CSSTSTATE]= "B"

optionsSAR_operacion[:CSBTSTREET1]= "Cerrito 740"
optionsSAR_operacion[:CSSTSTREET1]= "Cerrito 740"

optionsSAR_operacion[:CSBTCUSTOMERID]= "453458"
optionsSAR_operacion[:CSBTIPADDRESS]= "192.0.0.4"       
optionsSAR_operacion[:CSPTCURRENCY]= "ARS"
optionsSAR_operacion[:CSPTGRANDTOTALAMOUNT]= "125.38"
optionsSAR_operacion[:CSMDD7]= ""      
optionsSAR_operacion[:CSMDD8]= "Y"       
optionsSAR_operacion[:CSMDD9]= ""       
optionsSAR_operacion[:CSMDD10]= ""      
optionsSAR_operacion[:CSMDD11]= ""
optionsSAR_operacion[:CSMDD12]= ""     
optionsSAR_operacion[:CSMDD13]= ""     
optionsSAR_operacion[:CSMDD14]= ""      
optionsSAR_operacion[:CSMDD15]= ""        
optionsSAR_operacion[:CSMDD16]= ""
optionsSAR_operacion[:CSITPRODUCTCODE]= "electronic_good#chocho"
optionsSAR_operacion[:CSITPRODUCTDESCRIPTION]= "NOTEBOOK L845 SP4304LA DF TOSHIBA#chocho"     
optionsSAR_operacion[:CSITPRODUCTNAME]= "NOTEBOOK L845 SP4304LA DF TOSHIBA#chocho"  
optionsSAR_operacion[:CSITPRODUCTSKU]= "LEVJNSL36GN#chocho"
optionsSAR_operacion[:CSITTOTALAMOUNT]= "1254.40#10.00"
optionsSAR_operacion[:CSITQUANTITY]= "1#1"
optionsSAR_operacion[:CSITUNITPRICE]= "1254.40#15.00"

#Fin Control de Fraude


optionsSAR_comercio = Hash.new
optionsSAR_comercio[:Security]="1234567890ABCDEF1234567890ABCDEF"
optionsSAR_comercio[:MERCHANT]= "2153"
optionsSAR_comercio[:EncodingMethod]="XML"
optionsSAR_comercio[:URL_OK]= "http://someurl.com/ok/"
optionsSAR_comercio[:URL_ERROR]= "http://someurl.com/error/"
optionsSAR_comercio[:EMAILCLIENTE]= "mail@someurl.com"
optionsSAR_comercio[:Session]= "ABCDEF-1234-12221-FDE1-00000200"

response = conector.sendAuthorizeRequest(optionsSAR_comercio,optionsSAR_operacion)
puts(response)
puts('------------------------------------------------------------------------------------------------')

#GAA
optionsAnwser=Hash.new
optionsAnwser[:security]= "1234567890ABCDEF1234567890ABCDEF"
optionsAnwser[:MERCHANT]= "2153"
optionsAnwser[:RequestKey]= "710268a7-7688-c8bf-68c9-430107e6b9da"
optionsAnwser[:AnswerKey]= "693ca9cc-c940-06a4-8d96-1ab0d66f3ee6"

response = conector.getAuthorizeRequest(optionsAnwser)
puts(response)
puts('------------------------------------------------------------------------------------------------')

######################-################PaymentMethods#########################################
#GAPM
optionsPaymentMethods=Hash.new
optionsPaymentMethods[:MERCHANT]= "2153"

response = conector.getAllPaymentMethods(optionsPaymentMethods)
puts(response)
#Pasar del XML a Hash - Rails
#require 'active_support'
#hash = Hash.from_xml(response)
#Pasar del XML a Hash - sin Rails
#require 'xmlsimple'
#hash = XmlSimple.xml_in(response)
puts('------------------------------------------------------------------------------------------------')

#####################################Operations###############################################
#GS
optionsOperations=Hash.new
optionsOperations[:MERCHANT]= "2153"
optionsOperations[:OPERATIONID]= "02"

response = conector.getOperations(optionsOperations)
puts(response)
#Pasar del XML a Hash - Rails
#require 'active_support'
#hash = Hash.from_xml(response)
#Pasar del XML a Hash - sin Rails
#require 'xmlsimple'
#hash = XmlSimple.xml_in(response)
puts('------------------------------------------------------------------------------------------------')

