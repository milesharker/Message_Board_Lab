require 'bundler'
Bundler.require

DB = Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://db/main.db')
require './models.rb'

use Rack::Session::Cookie, :key => 'rack.session',
      :expire_after => 2592000,
      :secret => SecureRandom.hex(64)

get '/' do
    if session[:uid] && u=User[session[:uid]]
      @name = u.name

      erb :home
    else

      erb :main
    end
end

post '/create_user' do
  u = User.new
  u.name = params[:nuser]
  u.password = BCrypt::Password.create(params[:npass])
  u.save

  redirect '/'
end

post '/login' do
  u = User.first(:name => params[:user])
  if u && BCrypt::Password.new(u.password) == params[:pass]
    session[:uid] = u.id
  end
  redirect '/'
end

get '/draw' do
  erb :draw
end

post '/save' do
  p = Post.new
  p.imagedata = params[:imagedata]
  p.save

  redirect '/'
end
