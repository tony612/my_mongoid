require 'my_mongoid/fields'
require 'my_mongoid/errors'
require 'my_mongoid/attributes'
require 'my_mongoid/sessions'
require 'my_mongoid/creatable'
require 'my_mongoid/findable'
require 'my_mongoid/changable'

module MyMongoid
  module Document
    extend ActiveSupport::Concern

    include MyMongoid::Attributes
    include MyMongoid::Fields
    include MyMongoid::Sessions
    include MyMongoid::Creatable
    include MyMongoid::Findable
    include MyMongoid::Changable

    attr_accessor :is_new_record

    module ClassMethods
      def is_mongoid_model?
        true
      end

      def instantiate(attrs={})
        obj = allocate
        obj.attributes = attrs
        obj.is_new_record = false
        obj.clear_changed
        obj
      end
    end

    included do
      MyMongoid.register_model(self)
    end

    def initialize(attrs={})
      raise ArgumentError unless attrs.is_a?(Hash)
      process_attributes attrs_with_defaults({"_id" => SecureRandom.hex(10)}.merge(attrs))
      yield self if block_given?
      clear_changed
      @is_new_record = true
    end

    def new_record?
      @is_new_record
    end

    def to_document
      attributes
    end
  end
end
