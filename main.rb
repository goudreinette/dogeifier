require 'sinatra'


def dogeify(text)
  articles   = ['the', 'a', 'an']
  doge_words = ['many', 'such', 'wow', 'so']
  colors = ['red', 'green', 'blue', 'yellow', 'pink', 'orange']

  text.split(' ').map do |w|
    if articles.include? w.downcase
      "<span class='comicsans' style='color: #{colors.sample}'>
        #{doge_words.sample}
       </span>"
    else
      w
    end
  end.join ' '
end


get "/" do
  erb :index
end

post "/" do
  @text = dogeify(params[:text])
  erb :result
end
