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
  
  class App < Lydia::Application        
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
    
    get '/content_type' do
      content_type 'application/json'
      'body'
    end
    
    get '/redirect' do
      redirect '/new_url'
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
      expect(last_response.body).to eq('true')
    end
  end
  
  context 'View' do
    it 'render an erb template' do
      get '/render'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include('template')
    end      
  end
  
  context 'Helpers' do
    it 'responds to content_type' do
      get '/content_type'
      expect(last_response.status).to eq(200)
      expect(last_response.header['Content-Type']).to eq('application/json')
      expect(last_response.body).to eq('body')
    end
    
    it 'Handles redirect' do
      get '/redirect'
      expect(last_response.status).to eq(302)
      expect(last_response.body).to eq('/new_url')
    end     
  end

end