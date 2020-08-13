# typed: strict

module Vonage
  class KeySecretParams < AbstractAuthentication
    extend T::Sig

    sig { params(
      object: T.any(T::Hash[T.untyped, T.untyped], URI::HTTPS, Net::HTTP::Post, Net::HTTP::Get)
    ).void }
    def update(object)
      return unless object.is_a?(Hash)

      @config = T.let(@config, T.nilable(Vonage::Config))
      object[:api_key] = T.must(@config).api_key
      object[:api_secret] = T.must(@config).api_secret
    end
  end

  private_constant :KeySecretParams
end
