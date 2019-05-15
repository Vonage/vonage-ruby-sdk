module Nexmo
  class AbstractAuthentication
    def initialize(client)
      @client = client
    end
  end

  private_constant :AbstractAuthentication
end
