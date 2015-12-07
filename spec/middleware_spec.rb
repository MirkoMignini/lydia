require 'spec_helper'
require 'rack/test'
require 'erb'
require 'json'
require 'lydia/application'

describe "Middleware" do
  include Rack::Test::Methods

  class UpcaseMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      result = @app.call(env)
      result[2].body[0] = result[2].body[0].upcase
      result
    end
  end  
  
  class TestMiddleware < Lydia::Application
    use UpcaseMiddleware
    
    get '/hello' do
      'Hello world!'
    end
  end
  
  def app
    TestMiddleware.new
  end
  
  context 'Middleware stack' do
    it 'is correctly handled' do
      get '/hello'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq('HELLO WORLD!')
    end
  end
end