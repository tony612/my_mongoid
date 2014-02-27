module MyMongoid
  class DuplicateFieldError < StandardError
  end

  class UnknownAttributeError < StandardError
  end

  class AttributeTypeError < StandardError
  end
end
