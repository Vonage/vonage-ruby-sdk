module Nexmo
  module FormData # :nodoc:
    def self.update(http_request, params)
      http_request.form_data = params
    end
  end
end
