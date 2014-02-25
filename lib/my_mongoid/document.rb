module MyMongoid
  module Document
    extend ActiveSupport::Concern

    attr_accessor :attributes

    module ClassMethods
    end

    included do
      def self.is_mongoid_model?
        true
      end

      MyMongoid.register_model(self)
    end

    def initialize(attrs)
      raise ArgumentError unless attrs.is_a?(Hash)
      self.attributes = attrs
    end

    def attributes
      @attributes ||= {}
    end

    def read_attribute(key)
      key = key.to_s
      attributes[key]
    end

    def write_attribute(key, value)
      attributes[key] = value
    end

    def new_record?
      true
    end
  end
end
