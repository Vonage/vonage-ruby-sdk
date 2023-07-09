# typed: true
# frozen_string_literal: true

module Vonage
  class ProactiveConnect < Namespace
    extend T::Sig

    sig { returns(T.nilable(Vonage::ProactiveConnect::Lists)) }
    def lists
      @lists ||= Lists.new(@config)
    end

    sig { returns(T.nilable(Vonage::ProactiveConnect::List)) }
    def list
      @list ||= List.new(@config)
    end

    sig { returns(T.nilable(Vonage::ProactiveConnect::Items)) }
    def items
      @items ||= Items.new(@config)
    end

    sig { returns(T.nilable(Vonage::ProactiveConnect::Item)) }
    def item
      @item ||= Item.new(@config)
    end

    sig { returns(T.nilable(Vonage::ProactiveConnect::Events)) }
    def events
      @events ||= Events.new(@config)
    end
  end
end
