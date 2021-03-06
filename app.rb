require 'bundler/setup'
require 'sinatra'
require 'data_mapper'
require 'haml'

# conts for database
DB_HOST = "localhost" 	# host name
DB_USER = "postgres"	# username to login
DB_PASS = ""		# user password
DB_NAME = "mydns"	# the database name 

# database setup
# uncomment to display logs
DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, "postgres://#{DB_USER}:#{DB_PASS}@#{DB_HOST}/#{DB_NAME}")

# data models
# record table
class Rr
  include DataMapper::Resource

  property :id,		Serial
  property :zone,	Integer
  property :name,	String
  property :data,	String
  property :aux, 	Integer
  property :ttl, 	Integer
  property :type,	String
end
# soa table
class Soa
  include DataMapper::Resource

  property :id,		Serial
  property :origin, 	String
  property :ns, 	String
  property :mbox,	String
  property :serial,	Integer
  property :refresh, 	Integer
  property :retry,	Integer
  property :expire, 	Integer
  property :minimum, 	Integer
  property :ttl,	Integer
end

DataMapper.finalize

get '/' do
  haml :index
end

get '/zone' do
  @zones = Soa.all
  haml :zones
end

## zone methods
# zone create
get '/zone/add' do
  haml :zone_add
end

post '/zone/create' do
  zone = Soa.new({  :origin => params[:origin],
                    :ns => params[:ns],
                    :mbox => params[:mbox],
                    :serial => params[:serial],
                    :refresh => params[:refresh],
                    :retry => params[:retry],
                    :expire => params[:expire],
                    :minimum => params[:minimum],
                    :ttl => params[:ttl]
    })

  raw = request.env["rack.input"].read

  puts "RAW DATA: " + raw

  if zone.save
    status 201
    redirect '/zone'
  else
    status 412
    redirect '/zone'
  end
end

# zone read
get '/zone/:id' do
  @zone = Soa.get(params[:id])
  @records = Rr.all :zone => params[:id]
  haml :zone
end
# zone update
get '/zone/edit/:id' do
  @zone = Soa.get(params[:id])
  haml :zone_edit
end

post '/zone/update/:id' do
  soa = Soa.get(params[:id])
  soa.origin = params[:origin]
  soa.ns = params[:ns]
  soa.mbox = params[:mbox]
  soa.serial = params[:serial]
  soa.refresh = params[:refresh]
  soa.retry = params[:retry]
  soa.expire = params[:expire]
  soa.minimum = params[:minimum]
  soa.ttl = params[:ttl]

  if soa.save
    status 201
    redirect '/zone/' + params[:id]
  else
    status 412
    redirect '/zone/edit/' + params[:id]
  end
end
# zone delete
get '/zone/delete/:id' do
  Soa.get(params[:id]).destroy
  redirect '/zone'
end

## record methods
# record create
get '/record/add' do
  @zones = Soa.all
  haml :record_add
end

post '/record/create' do
    record = Rr.new({  :zone => params[:zone],
                    :name => params[:name],
                    :type => params[:type],
                    :data => params[:data],
                    :aux => params[:aux],
                    :ttl => params[:ttl]
    })

  if record.save
    status 201
    redirect '/zone/' + params[:zone]
  else
    status 412
    redirect '/zones'
  end
end

# record read
get '/record/:id' do
end
# record update
get '/record/edit/:id' do
end

post '/record/update/:id' do
end
# record delete
get '/record/delete/:id' do
  Rr.get(params[:id]).destroy
end
