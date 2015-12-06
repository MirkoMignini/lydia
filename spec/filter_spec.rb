require 'spec_helper'
require 'rack/test'
require 'lydia/application'

describe "Filters" do
  include Rack::Test::Methods

  class App < Lydia::Application        

    before do
      @filter = 'before'
    end
    
    after do
      @filter = 'after'
    end
    
    get '/filter' do
      @filter
    end
    
    namespace '/namespace' do
      before do
        @filter_nested = 'before'
      end
    
      after do
        @filter_nested = 'after'
      end
      
      get '/filter' do
        "#{@filter} #{@filter_nested}"
      end
    end
  end
  
  def app
    App.new
  end

  context 'Root' do
    it 'works without pattern' do
      get '/filter'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq('before')
    end
  end

  context 'Namespace' do
    it 'works without pattern' do
      get '/namespace/filter'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq('before before')
    end    
  end

end