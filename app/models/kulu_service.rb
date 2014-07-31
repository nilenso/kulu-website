class KuluService
  KULU_BACKEND_SERVICE_URL = ENV['KULU_BACKEND_SERVICE_URL']

  def initialize
    @conn = Faraday.new(:url => KULU_BACKEND_SERVICE_URL) do |faraday|
      faraday.request :url_encoded
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
    end
  end

  def create_invoice(storage_key)
    response = @conn.post do |req|
      req.url('/invoices')
      req.headers['Content-Type'] = 'application/json'
      req.body = {:storage_key => storage_key}.to_json
    end

    JSON.parse(response.body)['id']
  end
end
