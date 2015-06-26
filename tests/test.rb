ENV['RACK_ENV'] = 'test'

require 'digest'

Dir.glob('./db/*.rb').each {|file| require file}
DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
DataMapper.finalize



require 'test/unit'
require 'rack/test'
OUTER_APP = Rack::Builder.parse_file('config.ru').first

class TestApp < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    OUTER_APP
  end

  def test_home
    get '/'

    assert last_response.ok?
    assert last_response.body.include? 'Welcome to StudyMate'
    assert last_response.body.include? 'Login'
  end

  def test_auth
    if Users.all(:username => 'testuser').length != 0
      Users.all(:username => 'testuser')[0].destroy
    end

    get '/signup'

    assert last_response.ok?
    assert last_response.body.include? 'Username:'
    assert last_response.body.include? 'Sign Up!'

    post '/signup', {:name => 'Test', :username => 'testuser', :pass => '1234567890'}

    assert last_response.status === 302
    assert Users.all(:username => 'testuser').length == 1
    follow_redirect!
    assert last_response.body.include? 'Signed up sucessfully'
    assert last_response.body.include? '<a href="/logout" title="Logout">Logout</a>'

    get '/logout'

    get '/login'

    assert last_response.ok?
    assert last_response.body.include? '<a href="/login" title="Login">'
    assert last_response.body.include? 'Username:'

    post '/login', {:username => 'testuser', :password => '1234567890'}
    assert last_response.status === 302
    follow_redirect!
    assert last_response.body.include? 'Logged in'


    get '/logout'

    assert last_response.status === 302
    follow_redirect!
    assert last_response.body.include? 'You have logged out'
    assert last_response.body.include? 'Signup'
    Users.all(:username => 'testuser')[0].destroy
  end

  def test_tracks
    Users.create(:name => "Auto Tester for track", :username => 'autotracktester', :pass => Digest::SHA256.hexdigest('1234567890'))
    get '/tracks'
    assert last_response.ok?
    assert last_response.body.include? 'Create a new track'

    get '/tracks/new'
    assert last_response.status === 401

    post '/login', {:username => 'autotracktester', :password => '1234567890'}

    get '/tracks/new'

    assert last_response.ok?
    assert last_response.body.include? 'New Track'
    assert last_response.body.include? 'Description:'
    assert last_response.body.include? 'Save'

    post '/tracks/new', {:'track[name]' => 'Auto testing track', :'track[description]' => 'A dummy track created while testing the app'}
    assert last_response.status === 302
    trackurl = URI(last_response.location).path
    follow_redirect!
    assert last_response.body.include? 'Track created'
    assert last_response.body.include? 'Delete this track'

    get trackurl + '/edit'
    assert last_response.ok?
    assert last_response.body.include? 'Edit Auto testing track'
    assert last_response.body.include? 'Description:'
    assert last_response.body.include? 'Save'

    post trackurl , {:'track[name]' => 'Auto testing track Edited', :'track[description]' => 'A dummy track created while testing the app Edited', :'_method' => 'PUT'}
    assert last_response.status === 302
    follow_redirect!
    assert last_response.body.include? 'Track updated successfully'
 
    puts last_response.inspect
    
    Users.all(:username => 'autotracktester')[0].destroy
    Track.all(:name => 'Auto testing track Edited')[0].destroy

  end

end
