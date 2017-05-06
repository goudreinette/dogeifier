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
  nouns_str = nouns ? nouns.keys.join(' ') : ''
  gif = Giphy.search("doge #{nouns_str}").sample.fixed_width_image
  "<img style='background-image: url(#{gif.url});' width='#{gif.width}' height='#{gif.height}'/>"
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