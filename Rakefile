require 'bundler'
Bundler.require

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
end



