require 'rails_helper'
require 'http_service/connection_error'

RSpec.describe HTTPService::Connection, :type => :model do
  context 'post' do
    let(:bogus_request_uri) { 'http://www.google.com' }

    it 'it returns the response if request is successful' do
      expect(HTTPService::Connection.new(bogus_request_uri).check_errors(200, 'jacob')).to be_nil
    end

    it 'it raises a ClientError for a 4xx response' do
      expect {
        expect(HTTPService::Connection.new(bogus_request_uri).check_errors(400, 'jacob'))
      }.to raise_error(HTTPService::ClientError)
    end

    it 'it raises a ServerError for a 5xx response' do
      expect {
        expect(HTTPService::Connection.new(bogus_request_uri).check_errors(501, 'jacob'))
      }.to raise_error(HTTPService::ServerError)
    end
  end
end
