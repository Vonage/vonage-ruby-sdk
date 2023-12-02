# typed: true
# frozen_string_literal: true

module Vonage
  class Video < Namespace
    include Keys

    self.authentication = BearerToken

    self.host = :video_host

    # Generate a new session.
    #
    # @example
    #   session = client.video.create_session({
    #     archive_mode: 'always',
    #     location: '10.1.200.30',
    #     media_mode: 'routed'
    #   })
    #
    # @params [optional, String] :archive_mode (either 'always' or 'manual')
    #
    # @param [optional, String] :location
    #
    # @params [optional, String] :media_mode (either 'routed' or 'relayed')
    #
    # @return [Response]
    #
    # @see TODO: Add document link here
    #
    def create_session(**params)
      request_params = params.clone
      request_params[:archive_mode] ||= 'manual'
      media_mode = request_params.delete(:media_mode) || 'routed'

      if media_mode == 'relayed' && request_params[:archive_mode] == 'manual'
        request_params['p2p.preference'] = 'enabled'
      else
        request_params['p2p.preference'] = 'disabled'
      end

      response = request('/session/create', params: camelcase(request_params), type: Post)

      public_response_data = {
        session_id: response.entity.first.session_id,
        archive_mode: request_params[:archive_mode],
        media_mode: media_mode,
        location: request_params[:location]
      }

      entity = Entity.new(public_response_data)

      response.class.new(entity, response.http_response)
    end

    def generate_client_token(session_id:, scope: 'session.connect', role: 'publisher', **params)
      claims = {
        application_id: @config.application_id,
        scope: scope,
        session_id: session_id,
        role: role,
        initial_layout_class_list: '',
        sub: 'video',
        acl: {
          paths: {'/session/**' => {}}
        }
      }


      claims[:data] = params[:data] if params[:data]
      claims[:initial_layout_class_list] = params[:initial_layout_class_list].join(' ') if params[:initial_layout_class_list]
      claims[:exp] = params[:expire_time].to_i if params[:expire_time]

      JWT.generate(claims, @config.private_key)
    end

    # @return [Streams]
    #
    def streams
      @streams ||= Streams.new(@config)
    end

    # @return [Archives]
    #
    def archives
      @archives ||= Archives.new(@config)
    end

    # @return [Archives]
    #
    def moderation
      @moderation ||= Moderation.new(@config)
    end

    # @return [Archives]
    #
    def signals
      @signals ||= Signals.new(@config)
    end

    # TODO: add token generator
  end
end
