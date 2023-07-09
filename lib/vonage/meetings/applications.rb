# typed: true
# frozen_string_literal: true

module Vonage
  class Meetings::Applications < Namespace
    extend T::Sig

    self.authentication = BearerToken

    self.request_body = JSON

    self.host = :vonage_host

    # Update an existing application.
    #
    # @param [optional, String] default_theme_id (The id of the theme to set as application default theme)
    #
    # @return [Response]
    #
    # @see TODO: add docs link
    #
    # TODO: add type signature
    def update(**params)
      request("/beta/meetings/applications", params: params, type: Patch)
    end
  end
end
