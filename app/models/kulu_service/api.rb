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

    def list_invoices(options)
      page = (options[:page] || 1).to_i
      per_page = (options[:per_page] || Kaminari.config.default_per_page).to_i

      response = request.make(:get, 'invoices', {page: page, per_page: per_page})
      MultiJson.load(response.body)
    end

    def find_invoice(invoice_id)
      response = request.make(:get, "invoices/#{invoice_id}")
      MultiJson.load(response.body)
    end

    def update_invoice(invoice_id, params)
      response = request.make(:put, "invoices/#{invoice_id}", {invoice: params})
      MultiJson.load(response.body)
    end

    def list_currencies
      response = request.make(:get, 'currencies')
      MultiJson.load(response.body)
    end
  end
end
