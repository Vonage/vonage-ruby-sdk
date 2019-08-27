module Nexmo
  class KeySecretQuery < AbstractAuthentication
    def update(object)
      return unless object.is_a?(URI)

      object.query = Params.join(object.query, params)
    end

    private

    def params
      {
        api_key: @config.api_key,
        api_secret: @config.api_secret
      }
    end
  end

  private_constant :KeySecretQuery
end
