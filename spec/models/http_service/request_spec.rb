require 'rails_helper'
require 'http_service/error'

RSpec.describe HTTPService::Request, :type => :model do
  context 'check errors' do
    let(:bogus_request_uri) { 'http://www.google.com' }

    it 'does not return any errors' do
      expect(HTTPService::Request.new(bogus_request_uri).check_errors(200, 'jacob')).to be_nil
    end

    it 'raises a ClientError for a 4xx response' do
      expect {
        HTTPService::Request.new(bogus_request_uri).check_errors(400, 'jacob')
      }.to raise_error(HTTPService::ClientError)
    end

    it 'raises a ServerError for a 5xx response' do
      expect {
        HTTPService::Request.new(bogus_request_uri).check_errors(501, 'jacob')
      }.to raise_error(HTTPService::ServerError)
    end
  end
end
