require 'spec_helper'
require 'rack/test'
require 'lydia/application'

describe 'Helpers' do
  include Rack::Test::Methods

  class TestHelpers < Lydia::Application
    get '/content_type' do
      content_type 'application/json'
      'body'
    end

    get '/redirect' do
      redirect '/new_url'
    end

    get '/params' do
      params['key']
    end

    get '/file' do
      send_file('test.png')
    end
  end

  def app
    TestHelpers.new
  end

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

  it 'responds to params' do
    get '/params', key: 'value'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq('value')
  end

  it 'sends a file' do
    expect do
      get '/file'
    end.to raise_error(NotImplementedError)
  end
end
