require 'sinatra'
require 'giphy'
require 'dogeify/all'
require 'sinatra-websocket'

set :server, 'thin'
set :sockets, []

def get_gif
  gif = Giphy.random('doge')
  "<img style='background-image: url(#{gif.image_url});' width='#{gif.image_width}' height='#{gif.image_height}'/>"
end

def respond msg
  [get_gif, msg.dogeify].sample
end

get '/' do
  if !request.websocket?
    erb :index
  else
    request.websocket do |ws|
      ws.onmessage do |msg|
        ws.send(respond msg)
      end
    end
  end
end