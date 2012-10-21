module Nexmo
  class Response
    def initialize(http_response)
      @http_response = http_response
    end

    def method_missing(name, *args, &block)
      @http_response.send(name, *args, &block)
    end

    def ok?
      code.to_i == 200
    end

    def json?
      self['Content-Type'].split(?;).first == 'application/json'
    end

    def object
      ::Nexmo::Object.new(MultiJson.load(body))
    end
  end
end