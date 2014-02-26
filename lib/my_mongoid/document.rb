require 'my_mongoid/fields'
require 'my_mongoid/errors'
require 'my_mongoid/attributes'

module MyMongoid
  module Document
    extend ActiveSupport::Concern

    include MyMongoid::Attributes
    include MyMongoid::Fields

    module ClassMethods
      def is_mongoid_model?
        true
      end
    end

    included do
      MyMongoid.register_model(self)
    end

    def initialize(attrs)
      return unless attrs
      process_attributes attrs
    end

    def new_record?
      true
    end
  end
end
