module MyMongoid
  module Attributes
    attr_accessor :attributes

    def attributes
      @attributes ||= {}
    end

    def read_attribute(name)
      name = name.to_s
      attributes[name]
    end

    def write_attribute(name, value)
      attributes[name] = value
    end
  end
end
