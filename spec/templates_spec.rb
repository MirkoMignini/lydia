require 'spec_helper'
require 'rack/test'
require 'lydia/application'

describe "Templates" do
  include Rack::Test::Methods

  class TemplatesHelpers < Lydia::Application
    get '/render' do
      render 'spec/templates/template.erb', nil, message: 'template'
    end  
  end
  
  def app
    TemplatesHelpers.new
  end
  
  it 'render an erb template' do
    get '/render'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to include('template')
  end        
end