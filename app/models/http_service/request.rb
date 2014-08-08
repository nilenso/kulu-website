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

    def make(verb, request_url, request_body = {})
      response = send(verb, request_url, request_body)
      Response.new(response.status, response.body, response.headers)
    end

    def post(request_url, request_body = {})
      connection.post do |req|
        req.url(request_url)
        req.headers['Content-Type'] = 'application/json'
        req.body = request_body.to_json
      end
    end

    def get(request_url, request_body = {})
      connection.get do |req|
        req.url(request_url)
      end
    end
  end
end
