require "../lib/todo_pago_conector.rb"

j_header_http = {
    'Authorization'=>ARGV.fetch(0), 'Username'=>'>Test'
}

j_wsdls = {
    'Authorize'=> ARGV.fetch(1)}


conector = TodoPagoConector.new(j_header_http,
                                j_wsdls,
                                ARGV.fetch(2))



optionsSAR_comercio = Hash.new
optionsSAR_comercio[:MERCHANT]= ARGV.fetch(3)
optionsSAR_comercio[:EncodingMethod]= ARGV.fetch(4)
optionsSAR_comercio[:Security]= ARGV.fetch(5)
optionsSAR_comercio[:URL_OK]= ARGV.fetch(6)
optionsSAR_comercio[:URL_ERROR]= ARGV.fetch(7)
optionsSAR_comercio[:EMAILCLIENTE]= ARGV.fetch(8)
optionsSAR_comercio[:Session]= ARGV.fetch(9)

optionsSAR_operacion = Hash.new
optionsSAR_operacion[:MERCHANT]= ARGV.fetch(10)
optionsSAR_operacion[:OPERATIONID]= ARGV.fetch(11)
optionsSAR_operacion[:CURRENCYCODE]= ARGV.fetch(12)
optionsSAR_operacion[:AMOUNT]= ARGV.fetch(13)
    #fraud control
optionsSAR_operacion[:CSBTCITY]= ARGV.fetch(14)
optionsSAR_operacion[:CSBTEMAIL]= ARGV.fetch(15)
optionsSAR_operacion[:CSBTFIRSTNAME]= ARGV.fetch(16)
optionsSAR_operacion[:CSBTPOSTALCODE]= ARGV.fetch(17)
optionsSAR_operacion[:CSBTSTREET1]= ARGV.fetch(18)
optionsSAR_operacion[:CSBTIPADDRESS]= ARGV.fetch(19)
optionsSAR_operacion[:CSPTGRANDTOTALAMOUNT]= ARGV.fetch(20)
optionsSAR_operacion[:CSMDD6]= ARGV.fetch(21)
optionsSAR_operacion[:CSMDD8]= ARGV.fetch(22)
optionsSAR_operacion[:CSMDD10]= ARGV.fetch(23)
optionsSAR_operacion[:CSBTCOUNTRY]= ARGV.fetch(24)
optionsSAR_operacion[:CSBTPHONENUMBER]= ARGV.fetch(25)
optionsSAR_operacion[:CSBTLASTNAME]= ARGV.fetch(26)
optionsSAR_operacion[:CSBTSTATE]= ARGV.fetch(27)
optionsSAR_operacion[:CSBTSTREET2]= ARGV.fetch(28)
optionsSAR_operacion[:CSBTCUSTOMERID]= ARGV.fetch(29)
optionsSAR_operacion[:CSPTCURRENCY]= ARGV.fetch(30)
optionsSAR_operacion[:CSMDD7]= ARGV.fetch(31)
optionsSAR_operacion[:CSMDD9]= ARGV.fetch(32)
optionsSAR_operacion[:CSMDD11]= ARGV.fetch(33)
    #retail
optionsSAR_operacion[:CSSTCITY]= ARGV.fetch(34)
optionsSAR_operacion[:CSSTEMAIL]= ARGV.fetch(35)
optionsSAR_operacion[:CSSTFIRSTNAME]= ARGV.fetch(36)
optionsSAR_operacion[:CSSTPOSTALCODE]= ARGV.fetch(37)
optionsSAR_operacion[:CSSTSTREET1]= ARGV.fetch(38)
optionsSAR_operacion[:CSSTCOUNTRY]= ARGV.fetch(39)
optionsSAR_operacion[:CSSTPHONENUMBER]= ARGV.fetch(40)
optionsSAR_operacion[:CSSTLASTNAME]= ARGV.fetch(41)
optionsSAR_operacion[:CSSTSTATE]= ARGV.fetch(42)
optionsSAR_operacion[:CSSTSTREET2]= ARGV.fetch(43)
optionsSAR_operacion[:CSITPRODUCTCODE]= ARGV.fetch(44)
optionsSAR_operacion[:CSITPRODUCTNAME]= ARGV.fetch(45)
optionsSAR_operacion[:CSITTOTALAMOUNT]= ARGV.fetch(46)
optionsSAR_operacion[:CSITUNITPRICE]= ARGV.fetch(47)
optionsSAR_operacion[:CSITPRODUCTDESCRIPTION]= ARGV.fetch(48)
optionsSAR_operacion[:CSITPRODUCTSKU]= ARGV.fetch(49)
optionsSAR_operacion[:CSITQUANTITY]= ARGV.fetch(50)
optionsSAR_operacion[:CSMDD12]= ARGV.fetch(51)
optionsSAR_operacion[:CSMDD14]= ARGV.fetch(52)
optionsSAR_operacion[:CSMDD16]= ARGV.fetch(53)
optionsSAR_operacion[:CSMDD13]= ARGV.fetch(54)
optionsSAR_operacion[:CSMDD15]= ARGV.fetch(55) 
#Fin Control de Fraude

#AVAILABLEPAYMENTMETHODSIDS
if ARGV.fetch(56)=="1"
  optionsSAR_operacion[:AVAILABLEPAYMENTMETHODSIDS]= ARGV.fetch(57)
end
#PushNotifyMethod
if ARGV.fetch(58)=="1"
  optionsSAR_operacion[:PUSHNOTIFYMETHOD]=ARGV.fetch(59)
end
#PushNotifyEndpoint
if ARGV.fetch(60)=="1"
  optionsSAR_operacion[:PUSHNOTIFYENDPOINT]=ARGV.fetch(61)
end
#PushNotifyStates
if ARGV.fetch(62)=="1"
  optionsSAR_operacion[:PUSHNOTIFYSTATES]=ARGV.fetch(63)
end
#print optionsSAR_operacion, "\n"

response = conector.sendAuthorizeRequest(optionsSAR_comercio,optionsSAR_operacion)

print response, "\n"

STDOUT.flush