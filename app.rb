require 'bundler/setup'
require 'sinatra'
require 'savon'
require 'httparty'
require 'nokogiri'

client = Savon.client(wsdl: 'https://soapserviceserver.azurewebsites.net/WebServices/WebServer.asmx?WSDL')

# Principal
get '/' do
  erb :index
end

# Mensaje
get '/mensaje' do
  response = client.call(:mensaje)
  @mensaje_ws = response.body[:mensaje_response][:mensaje_result]
  erb :mensaje
end

# Información
get '/informacion' do
  response = client.call(:informacion)
  @informacion_ws = response.body[:informacion_response][:informacion_result]
  @datos = @informacion_ws.split(",")
  erb :informacion
end

# Operaciones
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

# Tabla
get '/tabla' do
  erb :tabla
end

post '/tabla' do
  response = client.call(:tabla, message: { numero: params[:n1] })
  @resultado = response.body[:tabla_response][:tabla_result][:string]
  @numero = params[:n1]
  erb :tabla
end

# Estudiantes
get '/estudiantes' do
  response = client.call(:estudiantes)
  estudiantes_result = response.body[:estudiantes_response][:estudiantes_result][:string]
  @students = estudiantes_result.map { |student| student.split(',') }
  erb :estudiantes
end

# Estudiantes2
get '/estudiantes2' do
  response = client.call(:estudiantes2)
  estudiantes_result = response.body[:estudiantes2_response][:estudiantes2_result][:string]
  @students = estudiantes_result.map { |student| student.split(',') }
  erb :estudiantes2
end
