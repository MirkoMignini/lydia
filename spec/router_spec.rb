require 'spec_helper'
require 'rack/test'
require 'lydia/router'

describe "Router" do
  include Rack::Test::Methods
  
  class Router < Lydia::Router
    get '/' do 
      get_response('<H1>Hello world!</H1>')
    end

    get '/204' do
      get_response('', 204)
    end

    get '/500' do
      raise StandardError.new('Error!')
    end  

    get '/querystring_params' do
      get_response(params['name'])
    end

    get '/wildcard/*' do
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
    
    get '/next_route' do
      next_route
    end
    
    get '/next_route' do
      get_response('Next route works!')
    end    
    
    namespace '/namespace' do
      get '/hello' do
        get_response('Hello from namespace')
      end
      
      namespace '/nested' do
        get '/hello' do
          get_response('Hello from nested namespace')
        end
      end
    end

    def get_response(body, status = 200)
      [status, { 'Content-Type' => 'text/html', 'Content-Length'=> body.length.to_s }, [body]]
    end
  end

  def app
    Router.new
  end

  context 'Status codes' do
    it 'returns 204' do
      get '/204'
      expect(last_response.status).to eq(204)  
    end

    it 'returns 404' do
      get '/not_found'
      expect(last_response.status).to eq(404)  
    end

    it 'returns 500' do
      get '/500'
      expect(last_response.status).to eq(500)  
    end    
  end

  context 'Response' do
    it "returns a valid response" do
      get '/'
      expect(last_response).to_not be_nil
      expect(last_response.status).to eq(200)
      expect(last_response.headers.to_hash).to eq({'Content-Type' => 'text/html', 'Content-Length' => '21'})
      expect(last_response.body).to eq('<H1>Hello world!</H1>')
    end
  end
  
  context 'Namespace' do
    it 'GET /namespace/hello' do
      get '/namespace/hello'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq('Hello from namespace')
    end
    
    it 'GET /namespace/nested/hello' do
      get '/namespace/nested/hello'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq('Hello from nested namespace')
    end    
  end  

  context 'Routing' do

    context 'Wildcards' do
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
    end

    context 'Regular expressions' do
      it 'GET /Regexp' do
        get '/Regexp'
        expect(last_response.status).to eq(200)
      end
    end
    
    context 'Next route' do
      it 'Goto next route' do
        get '/next_route'
        expect(last_response.status).to eq(200)
        expect(last_response.body).to eq('Next route works!')
      end
    end

    context 'Named parameters' do
      it 'GET /users/3/comments/138/edit' do
        get '/users/3/comments/138/edit'
        expect(last_response.status).to eq(200)
        expect(last_response.body).to eq('3-138')
      end

      it 'GET /api/v2/users' do
        get '/api/v2/users'
        expect(last_response.status).to eq(200)
        expect(last_response.body).to eq('2')
      end     
    end

    context 'Query string params' do
      it 'GET /querystring_params' do
        get '/querystring_params', { name: 'bob' }
        expect(last_response.status).to eq(200)
        expect(last_response.body).to eq('bob')
      end      
    end
    
    context 'Route not valid' do      
      it 'returns ArgumentError' do
        expect {
          class WrongRoute < Lydia::Router
            get Object do 
            end
          end  
        }.to raise_error(ArgumentError)
      end
    end
  end

  let(:router) { Lydia::Router.new }

  context 'Instance methods' do
    it 'responds to request' do
      expect(router).to respond_to(:request)
    end

    it 'responds to env' do
      expect(router).to respond_to(:env)
    end 

    it 'responds to params' do
      expect(router).to respond_to(:params)
    end     
  end

  context 'Class methods' do
    def app
      Router
    end
    
    it 'responds to call' do
      expect(Lydia::Router).to respond_to(:call)
    end
    
    it 'is initialized' do
      get '/'
      expect(last_response.status).to eq(200)
    end    
  end
  
end
