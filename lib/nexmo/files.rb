# frozen_string_literal: true

module Nexmo
  class Files < Namespace
    self.authentication = BearerToken

    def get(id)
      response = request('/v1/files/' + id.split('/').last)
      response.body
    end

    def save(id, filename)
      request('/v1/files/' + id.split('/').last) do |response|
        File.open(filename, 'wb') do |file|
          response.read_body do |chunk|
            file.write(chunk)
          end
        end
      end
    end
  end
end
