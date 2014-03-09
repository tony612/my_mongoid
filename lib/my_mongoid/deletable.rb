module MyMongoid
  module Deletable
    def delete
      self.class.collection.find({"_id" => id}).remove
    end
  end
end
