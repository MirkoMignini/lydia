require 'spec_helper'
require 'rack/test'

describe "Router" do
  include Rack::Test::Methods

  class OnlyRouter < Lydia::Router
    get '/' do 
      body = '<H1>Hello world!</H1>'
      [200, { 'Content-Type' => 'text/html', 'Content-Length'=> body.length.to_s }, [body]]
    end
  end
  
  def app
    OnlyRouter.new
  end
  
  it "returns ok" do
    get '/'
    expect(last_response).to_not be_nil
    expect(last_response.status).to eq(200)
    expect(last_response.headers.to_hash).to eq({'Content-Type' => 'text/html', 'Content-Length' => '21'})
    expect(last_response.body).to eq('<H1>Hello world!</H1>')
  end
end
