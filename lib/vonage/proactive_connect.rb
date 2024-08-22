# typed: true
# frozen_string_literal: true

module Vonage
  class ProactiveConnect < Namespace
    extend T::Sig

    # @deprecated
    sig { returns(T.nilable(Vonage::ProactiveConnect::Lists)) }
    def lists
      logger.info('This method is deprecated and will be removed in a future release.')
      @lists ||= Lists.new(@config)
    end

    # @deprecated
    sig { returns(T.nilable(Vonage::ProactiveConnect::List)) }
    def list
      logger.info('This method is deprecated and will be removed in a future release.')
      @list ||= List.new(@config)
    end

    # @deprecated
    sig { returns(T.nilable(Vonage::ProactiveConnect::Items)) }
    def items
      logger.info('This method is deprecated and will be removed in a future release.')
      @items ||= Items.new(@config)
    end

    # @deprecated
    sig { returns(T.nilable(Vonage::ProactiveConnect::Item)) }
    def item
      logger.info('This method is deprecated and will be removed in a future release.')
      @item ||= Item.new(@config)
    end

    # @deprecated
    sig { returns(T.nilable(Vonage::ProactiveConnect::Events)) }
    def events
      logger.info('This method is deprecated and will be removed in a future release.')
      @events ||= Events.new(@config)
    end
  end
end
