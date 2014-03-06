module MyMongoid
  module Fields
    extend ActiveSupport::Concern

    included do
      # define the default alias methods
      field :_id, :as => :id
    end

    module ClassMethods

      def field(name, opts={})
        add_field(name, opts)
      end

      def fields
        @fields ||= {}
      end

      def alias_methods
        @alias_methods ||= {}
      end

      def default_attributes
        @default_attributes ||= {}
      end

      def field_types
        @field_types ||= {}
      end

      def check_field_type(name, value)
        name = name.to_s
        matching_type = field_types[name]
        raise MyMongoid::AttributeTypeError if matching_type && !value.is_a?(matching_type)
        true
      end

      protected

      def add_field(name, opts)
        name = name.to_s
        check_field_name(name)
        create_accessor(name)
        fields[name] = MyMongoid::Field.new(name, opts)
        parse_options(name, opts)
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
          changed_attributes[name] = [attributes[name], value]
          write_attribute(name, value)
        end
      end

      def check_field_name(name)
        raise MyMongoid::DuplicateFieldError if fields.has_key?(name)
      end

      def parse_options(name, opts)
        opts.each do |key, val|
          key = key.to_s
          case key
          when "as"
            alias_methods[val.to_s] = name
            define_alias_method(val.to_s, name)
          when "default" then default_attributes[name] = val
          when "type" then field_types[name] = val if val.is_a?(Class)
          else
          end
        end
      end

      def define_alias_method(new_name, name)
        alias_method new_name, name
        alias_method "#{new_name}=", "#{name}="
      end
    end

  end

  class Field
    attr_reader :name, :options
    def initialize(name, opts={})
      @name = name
      @options = opts
    end
  end
end
