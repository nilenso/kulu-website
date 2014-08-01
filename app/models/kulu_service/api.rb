module KuluService
  class API
    KULU_BACKEND_SERVICE_URL = ENV['KULU_BACKEND_SERVICE_URL']

    def self.create_invoice(storage_key)
      backend = HTTPService::Request.new(KULU_BACKEND_SERVICE_URL)
      response = backend.post('/invoices', {storage_key: storage_key})
      MultiJson.load(response.body)['id']
    end
  end
end