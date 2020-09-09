# typed: true

module Vonage
  class Entity
    include Keys

    def initialize(attributes = nil)
      @attributes = attributes || {}
    end

    def [](key)
      @attributes[attribute_key(key)]
    end

    def []=(key, value)
      @attributes[attribute_key(key)] = value
    end

    def respond_to_missing?(name, include_private = false)
      @attributes.key?(name) or super
    end

    def method_missing(name, *args)
      return super unless @attributes.key?(name)

      @attributes[name]
    end

    def ==(entity)
      entity.class == self.class && entity.attributes == @attributes
    end

    def to_h
      @attributes
    end

    attr_reader :attributes

    protected :attributes

    def each_pair(&block)
      return to_enum(:each_pair) unless block

      @attributes.each_pair(&block)
    end

    alias_method :each, :each_pair

    include Enumerable
  end
end