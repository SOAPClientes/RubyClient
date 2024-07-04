require 'bundler/setup'
require 'sinatra'
require 'savon'

client = Savon.client(wsdl: 'https://soapserviceserver.azurewebsites.net/WebServices/WebServer.asmx?WSDL')

#Principal
get '/' do
  erb :index
end

#Mensaje
get '/mensaje' do
  response = client.call(:mensaje)
  @mensaje_ws = response.body[:mensaje_response][:mensaje_result]
  erb :mensaje
end

#Informacion
get '/informacion' do
  response = client.call(:informacion)
  @informacion_ws = response.body[:informacion_response][:informacion_result]
  @datos = @informacion_ws.split(",")
  erb :informacion
end

#Operaciones
get '/operaciones' do
  erb :operaciones
end

post '/operaciones' do
  response = client.call(:operaciones, message: {
    operacion: params[:operacion],
    valor1: params[:n1],
    valor2: params[:n2]
  })
  @resultado = response.body[:operaciones_response][:operaciones_result]
  @valor1 = params[:n1]
  @valor2 = params[:n2]
  erb :operaciones
end

#Tabla
get '/tabla' do
  erb :tabla
end

post '/tabla' do
  response = client.call(:tabla, message: { numero: params[:n1] })
  @resultado = response.body[:tabla_response][:tabla_result][:string]
  @numero = params[:n1]
  erb :tabla
end
