require "../lib/todo_pago_conector.rb"

j_header_http = {
    'Authorization'=>ARGV.fetch(0), 'Username'=>'>Test'
}

j_wsdls = {
    'Authorize'=> ARGV.fetch(1),
    'Services'=> ARGV.fetch(2)}


conector = TodoPagoConector.new(j_header_http,
                                j_wsdls,
                                ARGV.fetch(2))


optionsAnwser=Hash.new
optionsAnwser[:security]= ARGV.fetch(3)
optionsAnwser[:MERCHANT]= ARGV.fetch(4)
optionsAnwser[:RequestKey]= ARGV.fetch(5)
optionsAnwser[:AnswerKey]= ARGV.fetch(6)

response = conector.getAuthorizeRequest(optionsAnwser)
#Call GS
print response, "\n"

STDOUT.flush