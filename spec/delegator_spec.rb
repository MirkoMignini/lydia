require 'spec_helper'
require 'rack/test'
require 'lydia/delegator'

extend Lydia::Delegator

describe 'Delegator' do
  include Rack::Test::Methods
  
  class DelegatorTest
    extend Lydia::Delegator
    
    get '/hello' do
      'Hello world!'
    end
  end
  
  def app
    Lydia::Application.new
  end
  
  it 'Delegator initialize correctly' do
    expect(1).to eq(1)
  end
  
  it 'Delegates to Application' do
    get '/hello'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq('Hello world!')
  end
end