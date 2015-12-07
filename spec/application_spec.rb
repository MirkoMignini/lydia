require 'spec_helper'
require 'rack/test'
require 'rack/response'
require 'erb'
require 'lydia/application'

describe "Application" do
  include Rack::Test::Methods

  class API < Lydia::Application
    get '/users' do
      'Api call'
    end
  end
  
  class TestApplication < Lydia::Application        
    use Rack::Lint

    map '/api' do
      run API
    end
    
    get '/response' do
      respond_to?(:response).to_s
    end 
  
    get '/render' do
      render 'spec/templates/template.erb', nil, message: 'template'
    end      
    
    get '/empty' do
    end
    
    get '/rack_response' do
      Rack::Response.new(['Rack response'])
    end
  end
  
  def app
    TestApplication
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
      expect(last_response.body).to eq('true')
    end
    
    it 'Returns empty' do
      get '/empty'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq('')      
    end
    
    it 'Returns Rack::Response' do
      get '/rack_response'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq('Rack response')      
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