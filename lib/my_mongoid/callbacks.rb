require "active_model/callbacks"

module MyMongoid
  module Callbacks
    extend ActiveSupport::Concern

    included do
      extend ActiveModel::Callbacks

      define_model_callbacks :create, :save, :update, :delete
      define_model_callbacks :find, :initialize, only: [:after]
    end
  end
end
