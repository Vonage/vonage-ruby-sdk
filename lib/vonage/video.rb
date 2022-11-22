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
    #     p2p_preference: 'disabled'
    #   })
    #
    # @params [optional, String] :archive_mode
    #
    # @param [optional, String] :location
    #
    # @params [optional, String] :p2p_preference
    #
    # @return [Response]
    #
    # @see TODO: Add document link here
    #
    def create_session(**params)
      request_params = params.clone
      p2p_preference = request_params.delete(:p2p_preference)
      request_params['p2p.preference'] = p2p_preference if p2p_preference

      response = request('/session/create', params: camelcase(request_params), type: Post)

      params.keys.each {|key| response.entity[key] = params[key]}
      response
    end

    def generate_client_token(session_id:, application_id: @config.application_id, private_key: @config.private_key, scope: 'session.connect', role: 'publisher', **params)
      claims = {session_id: session_id, scope: scope, role: role}
      claims[:data] = params[:data] if params[:data]
      claims[:initial_layout_class_list] = params[:initial_layout_class_list].join(' ') if params[:initial_layout_class_list]
      claims[:expire_time] = params[:expire_time].to_i if params[:expire_time]

      JWT.generate(claims, private_key)
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
