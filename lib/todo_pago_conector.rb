#encoding: utf-8
require 'savon'
require 'rest-client'
require "json"

$versionTodoPago = '1.6.1'

$tenant = 't/1.1/'
$soapAppend = 'services/'
$restAppend = 'api/'

class TodoPagoConector
  # método inicializar clase
  def initialize(j_header_http, *args)#j_wsdl=nil, endpoint=nil, env=nil

      if args.length == 2

          j_wsdls  = args[0]
          endpoint = args[1]

      else args.length == 1

          j_wsdls = { 'Operations'=> '../lib/Operations.wsdl', 'Authorize'=> '../lib/Authorize.wsdl' }
          if args[0] == "prod"
              endpoint = 'https://apis.todopago.com.ar/'
          else
              endpoint = 'https://developers.todopago.com.ar/'
          end

      end

      # atributos
      $j_header_http = j_header_http
      $j_wsdls       = j_wsdls
      $discover      = nil
      @Fcv           = nil
      $endPoint = endpoint

  end

  ###########################################################################################
  #Metodo de clase que crea cliente que accede al servicio a través de SOAP utilizando savon
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

    # optionAuthorize[:SDK] = "Ruby"
    # optionAuthorize[:SDKVERSION] = $versionTodoPago
    # optionAuthorize[:LENGUAGEVERSION] = "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
	
    @xml = "<Request>"
    optionAuthorize.each do |item|
      @xml = @xml.concat("<").concat(item[0].to_s).concat(">")
      
      #crop values
      aux = if item[1].size > 254 then item[1].slice(0, 253)
      else
        item[1]
      end
      
      @xml = @xml.concat(aux)
      
      @xml = @xml.concat("</").concat(item[0].to_s).concat(">")
    end
    @xml = @xml.concat("</Request>");
    
    #puts(@xml);
    
    return @xml;
  end
  ######################################################################################
  # => Public method that calls first function service sendAuthorizeRequest          ###
  ######################################################################################
  def sendAuthorizeRequest(options_commerce, optionsAuthorize)
      begin
          message = {Security: options_commerce[:security],
                     Merchant: options_commerce[:MERCHANT],
                     EncodingMethod: options_commerce[:EncodingMethod],
                     URL_OK: options_commerce[:URL_OK],
                     URL_ERROR: options_commerce[:URL_ERROR],
                     EMAILCLIENTE: options_commerce[:EMAILCLIENTE],
                     Session: options_commerce[:Session],
                     Payload: TodoPagoConector.buildPayload(optionsAuthorize)}

          client = TodoPagoConector.getClientSoap($j_wsdls['Authorize'],'Authorize')
          
          response = client.call(:send_authorize_request, message: message)

          resp  = response.hash

          return resp.to_json
      rescue Exception=>e
          e.message
          #return e.message
      end     
  end
  #####################################################################################
  ###Metodo publico que llama a la segunda funcion del servicio GetAuthorizeAnswer###
  #####################################################################################
  # <b>DEPRECATED:</b> Please use <tt>getAuthorizeAnswer</tt> instead.
  def getAuthorizeRequest(optionsAnwser)
    warn "[DEPRECATION] 'getAuthorizeRequest' is deprecated.  Please use 'getAuthorizeAnswer' instead."
    return getAuthorizeAnswer(optionsAnwser)
  end

  def getAuthorizeAnswer(optionsAnwser)
    message = {Security: optionsAnwser[:security],
               Merchant: optionsAnwser[:MERCHANT],
               RequestKey: optionsAnwser[:RequestKey],
               AnswerKey: optionsAnwser[:AnswerKey]};

    client = TodoPagoConector.getClientSoap($j_wsdls['Authorize'],'Authorize')
    response= client.call(:get_authorize_answer,message:message)
    resp = response.hash
    return resp.to_json
  end

  ############################################################
  ###Metodo publico que retorna el status de una operacion###
  ############################################################
  def getOperations(optionsOperations)
    url = $endPoint + $tenant + $restAppend + 'Operations/GetByOperationId/MERCHANT/' + optionsOperations[:MERCHANT] + '/OPERATIONID/' + optionsOperations[:OPERATIONID]
    
    resource = RestClient::Resource.new(url, :verify_ssl => false)
    xml = resource.get( :Authorization => $j_header_http['Authorization'] )
	
	return xml
  end
  ################################################################
  ###Metodo publico que descubre todas las promociones de pago###
  ################################################################
  def getAllPaymentMethods(optionsPaymentMethod)
    url = $endPoint + $tenant + $restAppend + 'PaymentMethods/Get/MERCHANT/' + optionsPaymentMethod[:MERCHANT]
  	
  	resource = RestClient::Resource.new(url, :verify_ssl => false)
    xml = resource.get( :Authorization => $j_header_http['Authorization'] )
    
    
    return xml
  end


  ##############################################################################
  ###Metodo publico que descubre todas las operaciones en un rango de fechas###
  ##############################################################################
  ##$url = $this->end_point.TODOPAGO_ENDPOINT_TENATN.'api/Operations/GetByRangeDateTime/MERCHANT/'. $arr_datos["MERCHANT"] . '/STARTDATE/' . $arr_datos["STARTDATE"] . '/ENDDATE/' . $arr_datos["ENDDATE"] . '/PAGENUMBER/' . $arr_datos["PAGENUMBER"];
 
  def getByRangeDateTime(optionsAnswer)
    url = $endPoint + $tenant + $restAppend +"Operations/GetByRangeDateTime/MERCHANT/#{optionsAnswer[:Merchant]}/STARTDATE/#{optionsAnswer[:STARTDATE]}/ENDDATE/#{optionsAnswer[:ENDDATE]}/PAGENUMBER/#{optionsAnswer[:PAGENUMBER]}"         
    response = RestClient.get url
    return response
  end

  ##############################################################################
  ###Devolucion                                                              ###
  ##############################################################################

  def returnRequest(refoundOptions)
    message = {
      Security: refoundOptions[:Security],
      Merchant: refoundOptions[:Merchant],
      RequestKey: refoundOptions[:RequestKey],
      AMOUNT: refoundOptions[:AMOUNT]
    }

    client = TodoPagoConector.getClientSoap($j_wsdls['Authorize'], 'Authorize')
    response= client.call(:return_request, message:message)
    resp = response.hash
    return resp.to_json
  end

  ########################################################################
  ### GETCREDENTIALS######################################################
  ########################################################################
  def getCredentials(user)
    url = $endPoint + $restAppend +"Credentials"
    response = RestClient.post url, user.getData.to_json, :content_type => :json
    response = JSON.parse(response)
    if response['Credentials']['resultado']['codigoResultado'] != 0
    	raise ResponseException.new
    end
    user.merchant = response['Credentials']['merchantId']
    user.apiKey = response['Credentials']['APIKey']
    return user
  end

  ######################################################
  ###Methodo publico que descubre los metodos de pago###
  ######################################################
  def discoverPaymentMethods()
    url = $endPoint + $tenant + $restAppend + 'PaymentMethods/Discover' 
    resource = RestClient::Resource.new(url, :verify_ssl => false)
    xml = resource.get( :Authorization => $j_header_http['Authorization'] ) 
    return xml
  end


end





