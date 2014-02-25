module MyMongoid
  module Fields
    extend ActiveSupport::Concern

    module ClassMethods

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
  end

  class Field
    attr_reader :name
    def initialize(name)
      @name = name
    end
  end
end
