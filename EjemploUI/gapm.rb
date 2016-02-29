require "../lib/todo_pago_conector.rb"

#Configure TodoPago
j_header_http = {
'Authorization'=> ARGV.fetch(0), 'Username'=>'>Test'
}

j_wsdls = {
    'Authorize'=> ARGV.fetch(1)
    }


#init TodoPago
conector = TodoPagoConector.new(j_header_http, j_wsdls, ARGV.fetch(2))


#Configure GAPM
optionsPaymentMethods=Hash.new
optionsPaymentMethods[:MERCHANT]= ARGV.fetch(3)

#Call GS
response = conector.getAllPaymentMethods(optionsPaymentMethods)
print response, "\n"

STDOUT.flush