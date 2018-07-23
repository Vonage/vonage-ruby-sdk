module Nexmo
  module FormData
    def self.update(http_request, params)
      http_request.form_data = params
    end
  end
end
