require 'bundler'
Bundler.require

Dir.glob('./{helpers,models,controllers}/*.rb').each do |file|
  require file
end

require 'sinatra/activerecord/rake'

ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  database: 'glemur'
)

namespace :db do
  desc 'create glemur database'
  task :create_db do
    conn= PG::Connection.open()
    conn.exec('CREATE DATABASE glemur;')
    conn.close
  end

  desc 'drop glemur database'
  task :drop_db do
    conn= PG::Connection.open()
    conn.exec('DROP DATABASE glemur;')
    conn.close
  end

  desc 'create junk users'
  task :junk_data do
    user_1= User.new({first_name: 'Amanda', email: 'a@example.com', username: 'a'})
    user_1.password = ('a')
    user_1.save!

    user_2= User.new({first_name: 'Brad', email: 'brad@example.com', username: 'brad'})
    user_2.password = ('brad')
    user_2.save!

    user_3= User.new({first_name: 'Bob', email: 'bob@example.com', username: 'bob'})
    user_3.password = ('bob')
    user_3.save!

    user_4= User.new({first_name: 'May', email: 'may@example.com', username: 'may'})
    user_4.password = ('may')
    user_4.save!

  end
end



