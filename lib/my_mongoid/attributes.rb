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

    def process_attributes(attrs)
      raise ArgumentError unless attrs.is_a?(Hash)
      attrs.each do |name, val|
        name = name.to_s
        raise MyMongoid::UnknownAttributeError unless self.class.fields.keys.include?(name)
        self.send("#{name}=", val)
      end
    end
    alias :attributes= :process_attributes
  end
end
