require 'sinatra'
require 'dogeify/all'
require 'sinatra-websocket'

set :server, 'thin'
set :sockets, []

get '/' do
  if !request.websocket?
    erb :index
  else
    request.websocket do |ws|
      ws.onmessage do |msg|
        ws.send(msg.dogeify)
      end
    end
  end
end