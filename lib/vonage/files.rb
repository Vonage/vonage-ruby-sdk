# typed: strict
# frozen_string_literal: true

module Vonage
  class Files < Namespace
    extend T::Sig

    self.authentication = BearerToken

    sig { params(id: String).returns(T.nilable(Vonage::Response)) }
    def get(id)
      request('/v1/files/' + T.must(id.split('/').last))
    end

    sig { params(id: String, filename: String).returns(T.nilable(Vonage::Response)) }
    def save(id, filename)
      request('/v1/files/' + T.must(id.split('/').last)) do |response|
        File.open(filename, 'wb') do |file|
          response.read_body do |chunk|
            file.write(chunk)
          end
        end
      end
    end
  end
end
