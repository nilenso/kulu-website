module KuluService
  class API
    KULU_BACKEND_SERVICE_URL = ENV['KULU_BACKEND_SERVICE_URL']

    attr_reader :request

    def initialize
      @request = HTTPService::Request.new(KULU_BACKEND_SERVICE_URL)
    end

    def create_invoice(storage_key, token)
      #
      # FIXME:
      # Because we updated the create API to take these extra parameters without making them optional,
      # I'm changing it here because the change required in the backend will break the mobile client.
      # We need to fix it on the backend and update all the clients.
      # Until then, this hack will do - kit
      #
      stubbed_parameters = {remarks: '', expense_type: '', date: Date.today.iso8601}
      response = request.make(:post, 'invoices', {invoice: {storage_key: storage_key, user_token: token}.merge(stubbed_parameters)})
      MultiJson.load(response.body)['id']
    end

    def list_invoices(options)
      page = (options[:page] || 1).to_i
      per_page = (options[:per_page] || Kaminari.config.default_per_page).to_i

      response = request.make(:get, 'invoices', {page: page, per_page: per_page, order: (options[:sort] || 'created_at').downcase,
        direction: (options[:direction] || 'desc').downcase })
      MultiJson.load(response.body)
    end

    def find_invoice(id)
      response = request.make(:get, "invoices/#{id}")
      MultiJson.load(response.body)
    end

    def update_invoice(id, params)
      response = request.make(:put, "invoices/#{id}", {invoice: params})
      MultiJson.load(response.body)
    end

    def delete_invoice(id)
      response = request.make(:delete, "invoices/#{id}")
      response.status == 204
    end

    def list_currencies
      response = request.make(:get, 'currencies')
      MultiJson.load(response.body)
    end

    def list_of_states
      response = request.make(:get, 'states')
      MultiJson.load(response.body)
    end

    def next_and_prev_invoices(options)
      response = request.make(:get, "invoices/#{options[:id]}/next_and_prev_invoices", {order: options[:order], direction: options[:direction]})
      MultiJson.load(response.body)
    end
 end
end
