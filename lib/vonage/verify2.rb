# typed: true
# frozen_string_literal: true

module Vonage
  class Verify2 < Namespace
    self.authentication = BearerToken

    self.request_body = JSON

    # Request a verification be sent to a user.
    #
    # @example
    #   verification_request = client.verify2.start_verification(
    #     brand: 'Acme',
    #     workflow: [{channel: 'sms', to: '447000000000'}],
    #     code_length: 6
    #   )
    #
    # @param [required, String] :brand The brand that is sending the verification request
    #
    # @param [required, Array<Hash>] :workflow An array of hashes for channels in the workflow
    #
    # @param [optional, Hash] opts the options for the verification request.
    #   @option opts [Integer] :code_length The length of the one-time code provided to the end-user
    #   @option opts [String] :code An optional alphanumeric custom code to use instead of an auto-generated code
    #   @option opts [String] :locale The language to use for the verification message (where applicable)
    #   @option opts [Integer] :channel_timeout Wait time in seconds before trying the next channel in the workflow
    #   @option opts [String] :client_ref Reference to be included in callbacks
    #   @option opts [Boolean] If used, must be set to `false`. Will bypass a network block for a single Verify V2 request
    #
    # @return Vonage::Response
    # @see https://developer.vonage.com/en/api/verify.v2#newRequest
    #
    def start_verification(brand:, workflow:, **opts)
      raise ArgumentError, ':workflow must be an Array' unless workflow.is_a?(Array)
      raise ArgumentError, ':workflow must not be empty' if workflow.empty?

      request('/v2/verify/', params: opts.merge(brand: brand, workflow: workflow), type: Post)
    end

    # Check a supplied code against a request to see if it is valid.
    #
    # @example
    #   code_check = client.verify2.check_code(request_id: '7e8c5965-0a3f-44df-8a14-f1486209d8a2', code: '1234')
    #
    # @param [required, String] :request_id The request_id of the verification request being checked
    #
    # @param [required, String] :code The code supplied to the end-user by the verification request
    #
    # @see https://developer.vonage.com/en/api/verify.v2#checkCode
    #
    def check_code(request_id:, code:)
      request('/v2/verify/' + request_id, params: {code: code}, type: Post)
    end

    # Cancel a verifiction. If a verification request is still active, calling this method aborts the workflow.
    #
    # @example
    #   client.verify2.cancel_verification_request(request_id: '7e8c5965-0a3f-44df-8a14-f1486209d8a2')
    #
    # @param [required, String] :request_id The request_id of the verification request to be cancelled
    #
    # @see https://developer.vonage.com/en/api/verify.v2#cancelRequest
    #
    def cancel_verification_request(request_id:)
      request('/v2/verify/' + request_id, type: Delete)
    end

    # Instantiate a new Vonage::Verify2::StartVerificationOptions object
    #
    # @param [optional, Hash] opts the options for the verification request.
    #   @option opts [Integer] :code_length The length of the one-time code provided to the end-user
    #   @option opts [String] :code An optional alphanumeric custom code to use instead of an auto-generated code
    #   @option opts [String] :locale The language to use for the verification message (where applicable)
    #   @option opts [Integer] :channel_timeout Wait time in seconds before trying the next channel in the workflow
    #   @option opts [String] :client_ref Reference to be included in callbacks
    #   @option opts [Boolean] If used, must be set to `false`. Will bypass a network block for a single Verify V2 request
    #
    def start_verification_options(**opts)
      StartVerificationOptions.new(**opts)
    end

    # Instantiate a new Vonage::Verify2::Workflow object
    def workflow
      Workflow.new
    end

    # Return the Vonage::Verify2::WorkflowBuilder class
    def workflow_builder
      WorkflowBuilder.itself
    end
  end
end
