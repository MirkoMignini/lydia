require 'spec_helper'
require 'rack/test'
require 'lydia/delegator'

extend Lydia::Delegator

describe 'Delegator' do
  include Rack::Test::Methods

  class TestDelegator
    extend Lydia::Delegator

    get '/hello' do
      'Hello world!'
    end
  end

  def app
    Lydia::Application.new
  end

  it 'Delegates to Application' do
    get '/hello'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq('Hello world!')
  end
end
