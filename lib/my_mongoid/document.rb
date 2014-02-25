require 'my_mongoid/field'
require 'my_mongoid/errors'

module MyMongoid
  module Document
    extend ActiveSupport::Concern

    attr_accessor :attributes

    module ClassMethods
    end

    included do
      class << self
        def is_mongoid_model?
          true
        end

        def field(name)
          add_field(name)
        end

        def add_field(name)
          name = name.to_s
          check_field_name(name)
          create_accessor(name)
          fields[name] = MyMongoid::Field.new(name)
        end

        def create_accessor(name)
          create_getter(name)
          create_setter(name)
        end

        def create_getter(name)
          define_method(name.to_sym) do
            attributes[name]
          end
        end

        def create_setter(name)
          define_method("#{name}=".to_sym) do |value|
            attributes[name] = value
          end
        end

        def fields
          @fields ||= {"_id" => SecureRandom.hex}
        end

        def check_field_name(name)
          raise MyMongoid::DuplicateFieldError if fields.has_key?(name)
        end
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

    def read_attribute(name)
      name = name.to_s
      attributes[name]
    end

    def write_attribute(name, value)
      attributes[name] = value
    end

    def new_record?
      true
    end
  end
end
