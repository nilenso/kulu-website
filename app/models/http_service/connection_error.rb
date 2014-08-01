module HTTPService
  class ConnectionError < StandardError
    attr_accessor :response_body, :http_status

    def initialize(http_status, response_body)
      self.http_status = http_status

      # parse the response
      begin
        self.response_body = MultiJson.load(response_body)
      rescue MultiJson::DecodeError
        self.response_body = {}
      end

      # parse the errors out
      error_info = self.response_body['errors'] if self.response_body || {}

      # collect all the error keys and shove them into the message
      error_array = error_info.inject([]) { |a, (k, v)| a << "#{k}: #{v}" }

      if error_array.empty?
        message = self.response_body.to_s
      else
        message = error_array.join(', ')
      end

      message += " [HTTP #{http_status}]"

      super(message)
    end
  end

  # Any invalid response body
  class BadResponse < ConnectionError
  end

  # Any error with a 5xx HTTP status code
  class ServerError < ConnectionError
  end

  # Any error with a 4xx HTTP status code
  class ClientError < ConnectionError
  end
end
