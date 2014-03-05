require 'moped'
require 'active_support/inflector'

module MyMongoid
  module Sessions
    extend ActiveSupport::Concern

    module ClassMethods
      def collection_name
        self.to_s.tableize
      end

      def collection
        MyMongoid.session[collection_name]
      end
    end
  end

  def self.session
    raise UnconfiguredDatabaseError unless MyMongoid.config?
    @session ||= ::Moped::Session.new([MyMongoid.configuration.host], {database: MyMongoid.configuration.database})
  end
end
