module HTTPService
  class Request
    attr_reader :connection

    def initialize(url)
      @connection = Faraday.new(:url => url) do |faraday|
        faraday.request(:url_encoded)
        faraday.response(:logger)
        faraday.adapter(Faraday.default_adapter)
      end
    end

    def post(request_url, request_body)
      response = connection.post do |req|
        req.url(request_url)
        req.headers['Content-Type'] = 'application/json'
        req.body = request_body.to_json
      end

      check_errors(response.status, response.body)
      response
    end

    def check_errors(response_status, response_body)
      status = response_status.to_i

      if status >= 400
        if status >= 500
          raise(ServerError.new(status, response_body))
        else
          raise(ClientError.new(status, response_body))
        end
      end

      if response_body.empty?
        raise(BadResponse.new(status, response_body))
      end
    end
  end
end

