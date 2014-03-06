require 'active_support/inflector'
require 'my_mongoid/sessions'

module MyMongoid
  module Creatable
    extend ActiveSupport::Concern

    module ClassMethods
      def create(args={})
        m = new(args)
        m.save
        m
      end
    end

    def save
      @is_new_record = false
      self.class.collection.insert(to_document)
      clear_changed
    end
  end
end
