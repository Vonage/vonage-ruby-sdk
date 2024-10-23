# typed: true
# frozen_string_literal: true

module Vonage
  class Verify2::Templates < Namespace
    self.authentication = BearerToken

    self.request_body = JSON

    # Get a list of all templates.
    #
    # @example
    #   template_list = client.verify2.templates.list
    #
    # @param [optional, Integer] :page_size. The amount of templates to list per page
    #
    # @param [optional, Integer] :page. The page number to retrieve
    #
    # @return [ListResponse]
    #
    # @see https://developer.vonage.com/en/api/verify.v2#listTemplates
    def list(**params)
      request('/v2/verify/templates', params: params, response_class: ListResponse)
    end

    # Get details of a specific template.
    #
    # @example
    #   template = client.verify2.templates.info(template_id: '8f35a1a7-eb2f-4552-8fdf-fffdaee41bc9')
    #
    # @param [required, String] :template_id. The ID of the template to be retreived
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/verify.v2#getTemplate
    def info(template_id:)
      request('/v2/verify/templates/' + template_id)
    end

    # Create a new template.
    #
    # @example
    #   client.verify2.templates.create(name: 'my-template')
    #
    # @param [required, String] :name. The name of the template. The following characters are permitted: [A-Z a-z 0-9 _ -]
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/verify.v2#createTemplate
    def create(name:)
      request('/v2/verify/templates', params: { name: name }, type: Post)
    end

    # Update an existing template.
    #
    # @example
    #   client.verify2.templates.update(template_id: '8f35a1a7-eb2f-4552-8fdf-fffdaee41bc9', name: 'my-updated-template')
    #
    # @param [required, String] :template_id. The ID of the template to be updated
    #
    # @param [optional, String] :name. The name of the template. The following characters are permitted: [A-Z a-z 0-9 _ -]
    #
    # @param [optional, Boolean] :is_default. Whether the template is the default template for a specific locale/channel combination
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/verify.v2#updateTemplate
    def update(template_id:, **params)
      request('/v2/verify/templates/' + template_id, params: params, type: Patch)
    end

    # Delete a template.
    #
    # @example
    #   client.verify2.templates.delete(template_id: '8f35a1a7-eb2f-4552-8fdf-fffdaee41bc9')
    #
    # @param [required, String] :template_id. The ID of the template to be deleted
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/verify.v2#deleteTemplate
    def delete(template_id:)
      request('/v2/verify/templates/' + template_id, type: Delete)
    end
  end
end
