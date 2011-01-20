require 'sinatra'
require 'dm-core'
require 'rspec'

# Configure DataMapper to use the App Engine datastore 
DataMapper.setup(:default, "appengine://auto")

# Create your model class
class Shout
  include DataMapper::Resource
  
  property :id, Serial
  property :message, Text
end

# Make sure our template can use <%=h
helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

Rspec.configure do |config|
  # reset database before each example is run
  config.before(:each) { DataMapper.auto_migrate! }
end

get '/' do
  # Just list all the shouts
  @shouts = Shout.all
  erb :index
end

post '/' do
  # Create a new shout and redirect back to the list.
  shout = Shout.create(:message => params[:message])
  redirect '/'
end

get '/say/*/to/*' do
  # matches /say/hello/to/world
  params["splat"] # => ["hello", "world"]
end

get '/download/*.*' do
  # matches /download/path/to/file.xml
  params["splat"] # => ["path/to/file", "xml"]
end
get '/foo', :agent => /Songbird (\d\.\d)[\d\/]*?/ do
  "You're using Songbird version #{params[:agent][0]}"
end



__END__