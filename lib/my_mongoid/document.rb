require 'my_mongoid/fields'
require 'my_mongoid/errors'
require 'my_mongoid/attributes'
require 'my_mongoid/sessions'
require 'my_mongoid/creatable'

module MyMongoid
  module Document
    extend ActiveSupport::Concern

    include MyMongoid::Attributes
    include MyMongoid::Fields
    include MyMongoid::Sessions
    include MyMongoid::Creatable

    attr_accessor :is_new_record

    module ClassMethods
      def is_mongoid_model?
        true
      end
    end

    included do
      MyMongoid.register_model(self)
    end

    def initialize(attrs={})
      raise ArgumentError unless attrs.is_a?(Hash)
      process_attributes self.class.default_attributes.merge(attrs)
      yield self if block_given?
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
