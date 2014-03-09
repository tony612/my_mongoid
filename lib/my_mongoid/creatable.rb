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
      if new_record?
        run_callbacks :create do
          run_callbacks :save do
            !insert.try(:new_record?)
          end
        end
      else
        run_callbacks :save do
          update_document
        end
      end
    end

    protected

    def insert
      @is_new_record = false
      clear_changed
      self.class.collection.insert(to_document)
      self
    end
  end
end
