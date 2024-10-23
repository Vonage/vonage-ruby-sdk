# typed: true
# frozen_string_literal: true

module Vonage
  class Verify2::TemplateFragments < Namespace
    CHANNELS = ['sms', 'voice'].freeze

    self.authentication = BearerToken

    self.request_body = JSON

    # Get a list of of template fragments for a specific template.
    #
    # @example
    #   template_fragment_list = client.verify2.template_fragments.list(template_id: '8f35a1a7-eb2f-4552-8fdf-fffdaee41bc9')
    #
    # @param [required, String] :template_id. The ID of the template for which to retreive the fragments
    #
    # @param [optional, Integer] :page_size. The amount of template fragments to list per page
    #
    # @param [optional, Integer] :page. The page number to retrieve
    #
    # @return [ListResponse]
    #
    # @see https://developer.vonage.com/en/api/verify.v2#listTemplateFragments
    def list(template_id:, **params)
      request("/v2/verify/templates/#{template_id}/template_fragments", params: params, response_class: ListResponse)
    end

    # Get details of a specific template fragment.
    #
    # @example
    #   template_fragment = client.verify2.template_fragments.info(
    #                         template_id: '8f35a1a7-eb2f-4552-8fdf-fffdaee41bc9',
    #                         template_fragment_id: 'c70f446e-997a-4313-a081-60a02a31dc19'
    #                       )
    #
    # @param [required, String] :template_id. The ID of the template for which to retreive the fragment
    #
    # @param [required, String] :template_fragment_id. The ID of the fragment to be retreived
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/verify.v2#getTemplateFragment
    def info(template_id:, template_fragment_id:)
      request("/v2/verify/templates/#{template_id}/template_fragments/#{template_fragment_id}")
    end

    # Create a new template fragment.
    #
    # @example
    #   client.verify2.template_fragments.create(
    #                         template_id: '8f35a1a7-eb2f-4552-8fdf-fffdaee41bc9',
    #                         channel: 'sms',
    #                         locale: 'en-gb',
    #                         text: 'Your code is: ${code}'
    #                       )
    #
    # @param [required, String] :template_id. The ID of the template for which to create the fragment
    #
    # @param [required, String] :channel. The verification channel for which to create the fragment. Must be one of 'sms' or 'voice'
    #
    # @param [required, String] :locale. The locale for which to create the fragment.
    #
    # @param [required, String] :text. The text to be used in the template fragment.
    #   There are 4 reserved variables available to use as part of the text: ${code}, ${brand}, ${time-limit} and ${time-limit-unit}
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/verify.v2#addTemplateFragmentToTemplate
    def create(template_id:, channel:, locale:, text:)
      raise ArgumentError, "Invalid 'channel' #{channel}. Must be one of #{CHANNELS.join(', ')}" unless CHANNELS.include?(channel)
      request(
        "/v2/verify/templates/#{template_id}/template_fragments",
        params: {
          channel: channel,
          locale: locale,
          text: text
        },
        type: Post)
    end

    # Update an existing template fragment.
    #
    # @example
    #   client.verify2.template_fragments.update(
    #                         template_id: '8f35a1a7-eb2f-4552-8fdf-fffdaee41bc9',
    #                         template_fragment_id: 'c70f446e-997a-4313-a081-60a02a31dc19',
    #                         text: 'Your one-time code is: ${code}'
    #                       )
    #
    # @param [required, String] :template_id. The ID of the template with which the fragment to be updated is associated
    #
    # @param [required, String] :template_fragment_id. The ID of the fragment to be updated
    #
    # @param [required, String] :text. The text to be used in the template fragment.
    #   There are 4 reserved variables available to use as part of the text: ${code}, ${brand}, ${time-limit} and ${time-limit-unit}
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/verify.v2#updateTemplateFragment
    def update(template_id:, template_fragment_id:, text:)
      request("/v2/verify/templates/#{template_id}/template_fragments/#{template_fragment_id}", params: {text: text}, type: Patch)
    end

    # Delete a template fragment.
    #
    # @example
    #   client.verify2.template_fragments.delete(
    #                         template_id: '8f35a1a7-eb2f-4552-8fdf-fffdaee41bc9',
    #                         template_fragment_id: 'c70f446e-997a-4313-a081-60a02a31dc19'
    #                       )
    #
    # @param [required, String] :template_id. The ID of the template with which the fragment to be deleted is associated
    #
    # @param [required, String] :template_fragment_id. The ID of the fragment to be deleted
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/verify.v2#deleteTemplateFragment
    def delete(template_id:, template_fragment_id:)
      request("/v2/verify/templates/#{template_id}/template_fragments/#{template_fragment_id}", type: Delete)
    end
  end
end
