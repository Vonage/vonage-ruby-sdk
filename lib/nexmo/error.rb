module Nexmo
  class Error < StandardError
    attr_reader :status, :http_status

    # Initialize a new Error.
    #
    # status      - The response status code returned by the API.
    # http_status - The HTTP status code returned by the API.
    # message     - The error message.
    #
    # Returns nothing.
    def initialize(options = {})
      if options.kind_of?(Hash)
        @status = options[:status]
        @http_status = options[:http_status]
        super(options[:message])
      else
        super(options)
      end
    end
  end

  class AuthenticationError < Error; end
end
