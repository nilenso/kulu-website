module KuluService
  class API
    KULU_BACKEND_SERVICE_URL = ENV['KULU_BACKEND_SERVICE_URL']
    attr_reader :request

    def initialize
      @request = HTTPService::Request.new(KULU_BACKEND_SERVICE_URL)
    end

    def create_invoice(storage_key)
      response = request.make(:post, 'invoices', {storage_key: storage_key})
      MultiJson.load(response.body)['id']
    end

    def list_invoices
      response = request.make(:get, 'invoices')
      MultiJson.load(response.body)
    end
  end
end
