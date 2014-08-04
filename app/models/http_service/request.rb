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

      Response.new(response.status, response.body, response.headers)
    end

    def get(request_url, request_body = {})
      response = connection.get do |req|
        req.url(request_url)
      end

      Response.new(response.status, response.body, response.headers)
    end
  end
end

