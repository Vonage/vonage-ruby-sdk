module Nexmo
  class Object
    def initialize(attributes = {})
      @attributes = attributes.to_hash
    end

    def [](name)
      @attributes[name]
    end

    def []=(name, value)
      @attributes[name.to_s.tr(?-, ?_).to_sym] = value
    end

    def to_hash
      @attributes
    end

    def respond_to_missing?(name, include_private = false)
      @attributes.has_key?(name)
    end

    def method_missing(name, *args, &block)
      if @attributes.has_key?(name) && args.empty? && block.nil?
        @attributes[name]
      else
        super name, *args, &block
      end
    end
  end
end