require 'spec_helper'
require 'rack/test'
require 'erb'
require 'json'
require 'lydia/application'

describe "Application" do
  include Rack::Test::Methods

  class App < Lydia::Application        
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