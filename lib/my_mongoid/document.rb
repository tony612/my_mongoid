module MyMongoid
  module Document
    extend ActiveSupport::Concern

    module ClassMethods
    end

    included do
      def self.is_mongoid_model?
        true
      end

      MyMongoid.register_model(self)
    end
  end
end
