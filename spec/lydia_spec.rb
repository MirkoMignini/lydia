require 'spec_helper'
require 'rack/test'
require 'erb'
require 'json'

describe "Application" do
  include Rack::Test::Methods

  class App < Lydia::Application    
    get '/return_fixnum' do
      200
    end 
    
    get '/return_string' do
      'Body'
    end 
    
    get '/return_hash' do
      { key: 'value' }
    end
    
    get '/return_array2' do
      [200, 'Body']
    end
    
    get '/return_array2_body_array' do
      [200, ['Body']]
    end    
    
    get '/return_array3' do
      body = 'Body'
      [200, { 'Content-Type' => 'text/html', 'Content-Length'=> body.length.to_s }, body]
    end        
    
    class Stream
      def each
        10.times { |i| yield "#{i}" }
      end
    end
    
    get '/return_object_each' do
      Stream.new
    end
  
    get '/render' do
      render 'spec/templates/template.erb', nil, message: 'template'
    end
    
  end
  
  def app
    App.new
  end
  
  context 'Response types' do
    it 'fixnum' do
      get '/return_fixnum'
      expect(last_response.status).to eq(200)
    end
  
    it 'string' do
      get '/return_string'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq('Body')
    end
    
    it 'hash' do
      get '/return_hash'
      expect(last_response.status).to eq(200)
      expect(last_response.header['Content-Type']).to eq('application/json')
      expect(JSON.parse(last_response.body)).to eq({'key' => 'value'})
    end    
  
    it 'array of 2 (body is not an array)' do
      get '/return_array2'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq('Body')
    end
    
    it 'array of 2 (body is array)' do
      get '/return_array2_body_array'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq('Body')
    end    

    it 'array of 3' do
      get '/return_array3'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq('Body')
    end
    
    it 'obj that responds to each' do
      get '/return_object_each'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq('0123456789')
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