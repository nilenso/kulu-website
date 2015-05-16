module KuluService
  class ExtractorAPI
    KULU_BACKEND_SERVICE_URL = ENV['KULU_BACKEND_SERVICE_URL']

    attr_reader :request

    def initialize
      @request = HTTPService::Request.new(KULU_BACKEND_SERVICE_URL)
    end

    def list_invoices(options)
      page = (options[:page] || 1).to_i
      per_page = (options[:per_page] || Kaminari.config.default_per_page).to_i
      params = {page: page,
                per_page: per_page,
                order: (options[:sort] || 'created_at').downcase,
                direction: (options[:direction] || 'desc').downcase}.merge(options)
      response = request.make(:get, 'extractor/invoices', params, options[:token])
      MultiJson.load(response.body)
    end

    def find_invoice(options)
      response = request.make(:get, "extractor/invoices/#{options[:id]}", options, options[:token])
      MultiJson.load(response.body)
    end

    def update_invoice(options)
      response = request.make(:put, "extractor/invoices/#{options[:id]}", {
                                      invoice: options[:invoice]
                                  }, options[:token])
      MultiJson.load(response.body)
    end

    def login(options)
      response = request.make(:post, 'extractor/login', params: options)
      MultiJson.load(response.body)
    end
  end
end
