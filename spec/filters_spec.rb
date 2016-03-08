require 'spec_helper'
require 'rack/test'
require 'lydia/application'

describe 'Filters' do
  include Rack::Test::Methods

  class TestFilters < Lydia::Application
    before do
      @filter = 'before'
    end

    after do
      @filter = 'after'
    end

    get '/filter' do
      @filter
    end

    redirect '/redirect', to: '/redirected'

    get '/redirected' do
      'redirected'
    end

    namespace '/namespace' do
      before do
        @filter_nested = 'before'
      end

      after do
        @filter_nested = 'after'
      end

      redirect '/redirect', to: '/redirected'

      get '/redirected' do
        'redirected in namespace'
      end

      get '/filter' do
        "#{@filter} #{@filter_nested}"
      end
    end
  end

  def app
    TestFilters.new
  end

  context 'Before & after' do
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

  context 'Redirect' do
    context 'Root' do
      it 'redirects' do
        get '/redirect'
        expect(last_response.status).to eq(200)
        expect(last_response.body).to eq('redirected')
      end
    end

    context 'Namespace' do
      it 'redirects' do
        get '/namespace/redirect'
        expect(last_response.status).to eq(200)
        expect(last_response.body).to eq('redirected in namespace')
      end
    end
  end
end
