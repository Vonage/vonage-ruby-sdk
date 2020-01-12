# typed: ignore
module Nexmo
  class AbstractAuthentication
    def initialize(config)
      @config = config
    end
  end

  private_constant :AbstractAuthentication
end
