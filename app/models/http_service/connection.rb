module HTTPService
  class Connection
    attr_reader :connection

    def initialize(url)
      @connection = Faraday.new(:url => url) do |faraday|
        faraday.request(:url_encoded)
        faraday.response(:logger)
        faraday.adapter(Faraday.default_adapter)
      end
    end

    def post(url, body)
      response = connection.post do |req|
        req.url(url)
        req.headers['Content-Type'] = 'application/json'
        req.body = body.to_json
      end

      check_errors(response.status, response.body)
      response
    end

    def check_errors(status, body)
      status = status.to_i

      if status >= 400
        if status >= 500
          raise(ServerError.new(status, body))
        else
          raise(ClientError.new(status, body))
        end
      end

      if body.empty?
        raise(BadResponse.new(status, body))
      end
    end
  end
end

