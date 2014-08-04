module KuluService
  class API
    KULU_BACKEND_SERVICE_URL = ENV['KULU_BACKEND_SERVICE_URL']
    attr_reader :backend

    def initialize
      @backend = HTTPService::Request.new(KULU_BACKEND_SERVICE_URL)
    end

    def create_invoice(storage_key)
      response = backend.post('/invoices', {storage_key: storage_key})
      MultiJson.load(response.body)['id']
    end

    def all_invoices
      response = backend.get('/invoices')
      MultiJson.load(response.body)
    end
  end
end