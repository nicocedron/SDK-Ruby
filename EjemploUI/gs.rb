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


#Configure GS
optionsOperations=Hash.new
optionsOperations[:MERCHANT]= ARGV.fetch(3)
optionsOperations[:OPERATIONID]= ARGV.fetch(4)

print optionsOperations

#Call GS
response = conector.getOperations(optionsOperations)
print response, "\n"

STDOUT.flush