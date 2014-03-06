module MyMongoid
  module Changable
    def changed_attributes
      @changed_attributes ||= {}
    end

    def clear_changed
      @changed_attributes = {}
    end

    def changed?
      !@changed_attributes.empty?
    end
  end
end
