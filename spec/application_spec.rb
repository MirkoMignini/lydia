require 'spec_helper'
require 'rack/test'
require 'erb'
require 'json'
require 'lydia/application'

describe "Application" do
  include Rack::Test::Methods

  class API < Lydia::Application
    get '/users' do
      'Api call'
    end
  end
  
  class UpcaseMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    end
  end
  
  class App < Lydia::Application        
    use Rack::Lint
    use UpcaseMiddleware

    map '/api' do
      run API
    end
    
    get '/response' do
      'Body'
    end 
  
    get '/render' do
      render 'spec/templates/template.erb', nil, message: 'template'
    end
  end
  
  def app
    App.new
  end
  
  context 'Composition' do
    it 'GET /api/users' do
      get '/api/users'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq('Api call')
    end
  end
  
  context 'Response' do  
    it 'Response is handled' do
      get '/response'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq('Body')
    end
  end
  
  context 'View' do
    it 'render an erb template' do
      get '/render'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include('template')
    end      
  end

end