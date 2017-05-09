module Nexmo
  class Entity
    def initialize(**kwargs)
      @attributes = kwargs
    end

    def []=(key, value)
      name = self.class.attribute_names[key]

      @attributes[name] = value
    end

    def respond_to_missing?(name, include_private = false)
      @attributes.key?(name) or super
    end

    def method_missing(name)
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

    private

    def self.attribute_names
      @attribute_names ||= Hash.new do |hash, key|
        hash[key] = attribute_name(key)
      end
    end

    def self.attribute_name(key)
      return key if key.is_a?(Symbol)

      key.split(PATTERN).join(UNDERSCORE).downcase.to_sym
    end

    PATTERN = /[\-_]|(?<=\w)(?=[A-Z])/

    UNDERSCORE = '_'
  end
end
