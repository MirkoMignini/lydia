require 'spec_helper'
require 'lydia/response'

describe 'Response' do
  let(:response) { Lydia::Response.new }

  context 'initialization' do
    it 'is created' do
      expect(response).not_to be_nil
    end

    it 'contains default content type' do
      expect(response.headers).to include('Content-Type' => 'text/html')
    end
  end

  context 'build' do
    it 'responds to build' do
      expect(response).to respond_to(:build)
    end

    it 'builds using a string (body)' do
      body = 'Hello world!'
      result = response.build(body)
      expect(result).not_to be_nil
      expect(result).to be_an(Array)
      expect(result[0]).to eq(200)
      expect(result[1]).to include('Content-Type' => 'text/html')
      expect(result[1]).to include('Content-Length' => body.length.to_s)
      expect(result[2]).to be_an(Array)
      expect(result[2][0]).to eq(body)
    end

    it 'builds using a fixnum (status)' do
      status = 204
      result = response.build(status)
      expect(result).not_to be_nil
      expect(result).to be_an(Array)
      expect(result[0]).to eq(204)
      expect(result[1]).not_to include('Content-Type')
      expect(result[1]).not_to include('Content-Length')
      expect(result[2]).to be_an(Array)
      expect(result[2][0]).to be_nil
    end

    it 'builds using a hash (body)' do
      body = { hello: 'world' }
      result = response.build(body)
      expect(result).not_to be_nil
      expect(result).to be_an(Array)
      expect(result[0]).to eq(200)
      expect(result[1]).to include('Content-Type' => 'application/json')
      expect(result[1]).to include('Content-Length' => body.to_json.length.to_s)
      expect(result[2]).to be_an(Array)
      expect(result[2][0]).to eq(body.to_json)
    end

    it 'builds using an array of two (body is array)' do
      body = [201, ['Body']]
      result = response.build(body)
      expect(result).not_to be_nil
      expect(result).to be_an(Array)
      expect(result[0]).to eq(201)
      expect(result[1]).to include('Content-Type' => 'text/html')
      expect(result[1]).to include('Content-Length' => body[1][0].length.to_s)
      expect(result[2]).to be_an(Array)
      expect(result[2][0]).to eq(body[1][0])
    end

    it 'builds using an array of two (body is not an array)' do
      body = [201, 'Body']
      result = response.build(body)
      expect(result).not_to be_nil
      expect(result).to be_an(Array)
      expect(result[0]).to eq(201)
      expect(result[1]).to include('Content-Type' => 'text/html')
      expect(result[1]).to include('Content-Length' => body[1].length.to_s)
      expect(result[2]).to be_an(Array)
      expect(result[2][0]).to eq(body[1])
    end

    it 'builds using an array of three' do
      body = [201, { 'Authentication' => '12345' }, 'Body']
      result = response.build(body)
      expect(result).not_to be_nil
      expect(result).to be_an(Array)
      expect(result[0]).to eq(201)
      expect(result[1]).to include('Content-Type' => 'text/html')
      expect(result[1]).to include('Content-Length' => body[2].length.to_s)
      expect(result[1]).to include('Authentication' => '12345')
      expect(result[2]).to be_an(Array)
      expect(result[2][0]).to eq(body[2])
    end

    class Stream
      def each
        10.times { |i| yield i.to_s }
      end
    end

    context 'Stream' do
      it 'builds a valid stream object' do
        stream = ''
        Stream.new.each { |i| stream += i }
        expect(stream).to eq('0123456789')
      end

      it 'builds using an object that responds to :each' do
        result = response.build(Stream.new)
        expect(result).not_to be_nil
        expect(result).to be_an(Array)
        expect(result[0]).to eq(200)
        expect(result[1]).to include('Content-Type' => 'text/html')
        expect(result[1]).to include('Content-Length')
        expect(result[2]).to be_an(Array)
        expect(result[2][0]).not_to be_nil
      end
    end

    it 'returns ArgumentError if object is not allowed' do
      expect do
        response.build(nil)
      end.to raise_error(ArgumentError)
    end
  end
end
