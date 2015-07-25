require "../lib/todo_pago_conector.rb"

j_header_http = {
    'Authorization'=>'PRISMA 912EC803B2CE49E4A541068D495AB570', 'Username'=>'>Test'
}

j_wsdls = {
    'Authorize'=> 'https://23.23.144.247:8243/services/Authorize?wsdl',
    'PaymentMethods'=>'https://23.23.144.247:8243/services/PaymentMethods?wsdl',
    'Operations'=> 'https://23.23.144.247:8243/services/Operations?wsdl'}


conector = TodoPagoConector.new(j_header_http,
                                j_wsdls,
                                "https://23.23.144.247:8243/services/")

##############################################Authorize################################################
optionsSAR_operacion = Hash.new
optionsSAR_operacion[:MERCHANT] = "305"
optionsSAR_operacion[:OPERATIONID] = "ABCDEF-1234-12221-FDE1-00000200"
optionsSAR_operacion[:CURRENCYCODE] = "032"
optionsSAR_operacion[:AMOUNT] = "50"

optionsSAR_comercio = Hash.new
optionsSAR_comercio[:Security]="1234567890ABCDEF1234567890ABCDEF"
optionsSAR_comercio[:Merchant]= "350"
optionsSAR_comercio[:EncodingMethod]="XML"

response = conector.sendAuthorizeRequest(optionsSAR_comercio,optionsSAR_operacion)
puts(response)

#GAA
optionsAnwser=Hash.new
optionsAnwser[:security]= "1234567890ABCDEF1234567890ABCDEF"
optionsAnwser[:MERCHANT]= "305"
optionsAnwser[:RequestKey]= "8496472a-8c87-e35b-dcf2-94d5e31eb12f"
optionsAnwser[:AnswerKey]= "8496472a-8c87-e35b-dcf2-94d5e31eb12f"

response = conector.getAuthorizeRequest(optionsAnwser)
puts(response)

######################-################PaymentMethods#########################################
#GAPM
optionsPaymentMethods=Hash.new
optionsPaymentMethods[:MERCHANT]= "305"

response = conector.getAllPaymentMethods(optionsPaymentMethods)
puts(response)

#####################################Operations###############################################
#GS
optionsOperations=Hash.new
optionsOperations[:MERCHANT]= "305"
optionsOperations[:OPERATIONID]= "141120084707"

response = conector.getOperations(optionsOperations)
puts(response)
