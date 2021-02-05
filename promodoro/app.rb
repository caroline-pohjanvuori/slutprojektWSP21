require 'slim'
require 'sinatra'
enable :sessions

get('/') do
    slim(:index)
end
