require 'sinatra'
require 'giphy'
require 'dogeify/all'
require 'sinatra-websocket'
require 'engtagger'

set :server, 'thin'
set :sockets, []

def get_gif msg
  tgr = EngTagger.new
  tagged = tgr.add_tags(msg)
  nouns = tgr.get_nouns(tagged)
  gif = Giphy.random("doge #{nouns ? nouns.keys.join(' ') : ''}")
  "<img style='background-image: url(#{gif.image_url});' width='#{gif.image_width}' height='#{gif.image_height}'/>"
end

def respond msg
  [get_gif(msg), msg.dogeify].shuffle.first
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