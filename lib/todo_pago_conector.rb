require 'savon'
require 'rest-client'

$versionTodoPago = '1.0.2'


$tenant = 't/1.1/'
$soapAppend = 'services/'
$restAppend = 'api/'

class TodoPagoConector
  # método inicializar clase
  def initialize(j_header_http, j_wsdls, endpoint)
    # atributos
    $j_header_http = j_header_http
    $j_wsdls = j_wsdls
    $endPoint = endpoint #recibe endpoint incompleto
  end

  ###########################################################################################
  #Methodo de clase que crea cliente que accede al servicio a través de SOAP utilizando savon
  ###########################################################################################
  def self.getClientSoap(wsdlService,sufijoEndpoint)
    return Savon.client(
        headers:$j_header_http,
        wsdl: wsdlService,
        endpoint: $endPoint + $soapAppend + $tenant +sufijoEndpoint,
        log: false,
        log_level: :debug,
        ssl_verify_mode: :none,
        convert_request_keys_to: :none)
  end

  def self.buildPayload(optionAuthorize)
    @xml = "<Request>"
    optionAuthorize.each do |item|
      @xml = @xml.concat("<")
                 .concat(item[0].to_s)
                 .concat(">")
                 .concat(item[1])
                 .concat("</")
                 .concat(item[0].to_s)
                 .concat(">")
    end
    @xml = @xml.concat("</Request>");
    return @xml;
  end
  ######################################################################################
  ###Methodo publico que llama a la primera funcion del servicio SendAuthorizeRequest###
  ######################################################################################
  def sendAuthorizeRequest(options_comercio, options_operacion)

    message = {Security: options_comercio[:security],
               Merchant: options_comercio[:MERCHANT],
               EncodingMethod: options_comercio[:EncodingMethod],
               URL_OK: options_comercio[:URL_OK],
               URL_ERROR: options_comercio[:URL_ERROR],
               EMAILCLIENTE: options_comercio[:EMAILCLIENTE],
               Session: options_comercio[:Session],
               Payload: TodoPagoConector.buildPayload(options_operacion)};

    client = TodoPagoConector.getClientSoap($j_wsdls['Authorize'],'Authorize');
    response = client.call(:send_authorize_request, message: message)
    return response.hash
  end
  #####################################################################################
  ###Methodo publico que llama a la segunda funcion del servicio GetAuthorizeRequest###
  #####################################################################################
  def getAuthorizeRequest(optionsAnwser)
    message = {Security: optionsAnwser[:security],
               Merchant: optionsAnwser[:MERCHANT],
               RequestKey: optionsAnwser[:RequestKey],
               AnswerKey: optionsAnwser[:AnswerKey]};

    client = TodoPagoConector.getClientSoap($j_wsdls['Authorize'],'Authorize')
    response= client.call(:get_authorize_answer,message:message)
    return response.hash
  end

  ############################################################
  ###Methodo publico que retorna el status de una operacion###
  ############################################################
  def getOperations(optionsOperations)
    url = $endPoint + $tenant + $restAppend + 'Operations/GetByOperationId/MERCHANT/' + optionsOperations[:MERCHANT] + '/OPERATIONID/' + optionsOperations[:OPERATIONID]
    #url = $j_wsdls['Services'] + 'api/Operations/GetByOperationId/MERCHANT/' + optionsOperations[:MERCHANT] + '/OPERATIONID/' + optionsOperations[:OPERATIONID]
    xml = RestClient.get url
	return xml
  end
  ################################################################
  ###Methodo publico que descubre todas las promociones de pago###
  ################################################################
  def getAllPaymentMethods(optionsPaymentMethod)
    url = $endPoint + $tenant + $restAppend + 'PaymentMethods/Get/MERCHANT/' + optionsPaymentMethod[:MERCHANT]
  	#url = $j_wsdls['Services'] + 'api/PaymentMethods/Get/MERCHANT/' + optionsPaymentMethod[:MERCHANT]
  	xml = RestClient.get url
    return xml
  end
end