require 'spec_helper'
require 'rack/test'
require 'lydia/application'

describe 'Templates' do
  include Rack::Test::Methods

  class TemplatesHelpers < Lydia::Application
    get '/render_erb' do
      render 'spec/templates/template.erb', nil, message: 'template'
    end

    get '/render_haml' do
      render 'spec/templates/template.haml', Object.new, message: 'template'
    end
  end

  def app
    TemplatesHelpers.new
  end

  it 'render an erb template' do
    get '/render_erb'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to include('template')
  end

  it 'render an haml template' do
    get '/render_haml'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to include('template')
  end
end
