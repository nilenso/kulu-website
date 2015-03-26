module KuluService
  class API
    KULU_BACKEND_SERVICE_URL = ENV['KULU_BACKEND_SERVICE_URL']

    attr_reader :request

    def initialize
      @request = HTTPService::Request.new(KULU_BACKEND_SERVICE_URL)
    end

    def create_invoice(options)
      #
      # FIXME:
      # Because we updated the create API to take these extra parameters without making them optional,
      # I'm changing it here because the change required in the backend will break the mobile client.
      # We need to fix it on the backend and update all the clients.
      # Until then, this hack will do - kit
      #
      stubbed_parameters = {remarks: '', expense_type: '', date: Date.today.iso8601}
      params = {organization_name: options[:org_name],
                :invoice => {storage_key: options[:storage_key],
                             user_token: options[:user_token]}.merge(stubbed_parameters)}

      response = request.make(:post, 'invoices', params, options[:token])
      MultiJson.load(response.body)['id']
    end

    def list_invoices(options)
      page = (options[:page] || 1).to_i
      per_page = (options[:per_page] || Kaminari.config.default_per_page).to_i
      params = {organization_name: options[:organization_name],
                page: page,
                per_page: per_page,
                order: (options[:sort] || 'created_at').downcase,
                direction: (options[:direction] || 'desc').downcase}.merge(options)
      response = request.make(:get, 'invoices', params, options[:token])
      MultiJson.load(response.body)
    end

    def find_invoice(options)
      response = request.make(:get, "invoices/#{options[:id]}", options, options[:token])
      MultiJson.load(response.body)
    end

    def update_invoice(options)
      response = request.make(:put, "invoices/#{options[:id]}", {invoice: params}, options[:token])
      MultiJson.load(response.body)
    end

    def delete_invoice(id, token)
      response = request.make(:delete, "invoices/#{id}", {}, token)
      response.status == 204
    end

    def list_of_states(options)
      response = request.make(:get, 'invoices/states', {organization_name: options[:organization_name]}, options[:token])
      MultiJson.load(response.body)
    end

    def next_and_prev_invoices(options)
      params = {organization_name: options[:organization_name], order: options[:order], direction: options[:direction]}
      response = request.make(:get, "invoices/#{options[:id]}/next_and_prev_invoices", params, options[:token])
      MultiJson.load(response.body)
    end

    def list_currencies
      response = request.make(:get, 'currencies')
      MultiJson.load(response.body)
    end


    def signup(options)
      response = request.make(:post, 'signup', signup: options)
      MultiJson.load(response.body)
    end

    def login(options)
      response = request.make(:post, 'login', creds: options)
      MultiJson.load(response.body)
    end
  end
end
