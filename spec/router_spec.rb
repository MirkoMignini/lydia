require 'spec_helper'
require 'rack/test'

describe "Router" do
  include Rack::Test::Methods

  class Router < Lydia::Router
    get '/' do 
      get_response('<H1>Hello world!</H1>')
    end
    
    get '/querystring_params' do
      get_response(params['name'])
    end
    
    get '/wildcard/*' do
      get_response('')
    end
    
    get '/request' do
      raise StandardError unless request.is_a? Lydia::Request
      get_response('')
    end
    
    get '/env' do
      raise StandardError unless env.is_a? Hash
      get_response('')
    end    
    
    get %r{/regexp$}i do
      get_response('')
    end    
    
    get '/users/:id/comments/:comment_id/edit' do
      get_response("#{params[:id]}-#{params[:comment_id]}")
    end
    
    get '/api/v:version/users' do
      get_response(params[:version])
    end

    def get_response(body)
      [200, { 'Content-Type' => 'text/html', 'Content-Length'=> body.length.to_s }, [body]]
    end
  end
  
  def app
    Router.new
  end
  
  it "returns ok" do
    get '/'
    expect(last_response).to_not be_nil
    expect(last_response.status).to eq(200)
    expect(last_response.headers.to_hash).to eq({'Content-Type' => 'text/html', 'Content-Length' => '21'})
    expect(last_response.body).to eq('<H1>Hello world!</H1>')
  end
  
  it 'GET wildcard' do
    get '/wildcard'
    expect(last_response.status).to eq(200)
  end
  
  it 'GET wildcard/' do
    get '/wildcard/'
    expect(last_response.status).to eq(200)
  end
  
  it 'GET wildcard/hello' do
    get '/wildcard/hello'
    expect(last_response.status).to eq(200)
  end  
  
  it 'GET wildcard/hello/bob' do
    get '/wildcard/hello/bob'
    expect(last_response.status).to eq(200)
  end
  
  it 'GET querystring params' do
    get '/querystring_params', { name: 'bob' }
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq('bob')
  end
  
  it 'has a request method' do
    get '/request'
    expect(last_response.status).to eq(200)
  end
  
  it 'has a env method' do
    get '/env'
    expect(last_response.status).to eq(200)
  end  
  
  it 'returns 200' do
    get '/Regexp'
    expect(last_response.status).to eq(200)
  end  
  
  it 'named parameters' do
    get '/users/3/comments/138/edit'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq('3-138')
  end
  
  it 'named parameters with prefix' do
    get '/api/v2/users'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq('2')
  end  
end
