require 'spec_helper'
require 'rack/test'
require 'erb'
require 'json'

describe "Lydia" do
  include Rack::Test::Methods

  class App < Lydia::Application
    get '/' do 
      body = '<H1>Hello world!</H1>'
      [200, { 'Content-Type' => 'text/html', 'Content-Length'=> body.length.to_s }, [body]]
    end

    get %r{/regexp$}i do
      body = 'Regexp'
      [200, { 'Content-Type' => 'text/html', 'Content-Length'=> body.length.to_s }, [body]]
    end

    get '/status' do
      200
    end

    get '/string' do
      'Works!'
    end
    
    get '/500' do
      raise Exception.new('Error!')
    end
    
    get '/render' do
      render 'spec/templates/template.erb', nil, message: 'template'
    end
    
    class Stream
      def each
        10.times { |i| yield "#{i}" }
      end
    end
    
    get '/stream' do
      Stream.new
    end
    
    get '/hash' do
      {
        key: 'value'
      }
    end
  end
  
  def app
    App.new
  end
  
  it "returns ok" do
    get '/'
    expect(last_response).to_not be_nil
    expect(last_response.status).to eq(200)
    expect(last_response.headers.to_hash).to eq({'Content-Type' => 'text/html', 'Content-Length' => '21'})
    expect(last_response.body).to eq('<H1>Hello world!</H1>')
  end
  
  it 'returns 404' do
    get '/not_found'
    expect(last_response.status).to eq(404)
  end
  
  it 'returns 500' do
    get '/500'
    expect(last_response.status).to eq(500)
  end
  
  it 'returns 200' do
    get '/Regexp'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq('Regexp')
  end
  
  it '/status' do
    get '/status'
    expect(last_response.status).to eq(200)
  end
  
  it '/string' do
    get '/string'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq('Works!')
  end  
  
  it '/render' do
    get '/render'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to include('template')
  end
  
  it '/stream' do
    get '/stream'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq('0123456789')
  end
  
  it '/hash' do
    get '/hash'
    expect(last_response.status).to eq(200)
    expect(last_response.header['Content-Type']).to eq('application/json')
    expect(JSON.parse(last_response.body)).to eq({'key' => 'value'})
  end
end

