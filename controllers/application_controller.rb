class ApplicationController < Sinatra::Base
  helpers Sinatra::AuthenticationHelper
  ActiveRecord::Base.establish_connection({
    adapter: 'postgresql',
    database: 'glemur'
    })

  set :views, File.expand_path('../../views',__FILE__)
  set :public_dir, File.expand_path('../../public',__FILE__)

  enable :sessions, :method_override
  after { ActiveRecord::Base.connection.close }

  get '/' do
    erb :index
  end

  get '/console' do
    binding.pry
  end
end
