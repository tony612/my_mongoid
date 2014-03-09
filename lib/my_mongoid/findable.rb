module MyMongoid
  module Findable
    extend ActiveSupport::Concern

    def reload
      self.attributes = self.class.collection.find({"_id" => id}).first
    end

    module ClassMethods
      def find(opts=nil)
        attrs = if opts.is_a?(Hash)
                  collection.find(opts).first
                else
                  collection.find({"_id" => opts}).first
                end
        raise MyMongoid::RecordNotFoundError unless attrs && attrs.is_a?(Hash)
        instantiate(attrs)
      end
    end
  end
end
