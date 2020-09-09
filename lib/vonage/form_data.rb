# typed: ignore

module Vonage
  module FormData
    def self.update(http_request, params)
      http_request.form_data = params
    end
  end

  private_constant :FormData
end
