module MyMongoid
  module Updatable
    def atomic_updates
      changed_attrs = changed.inject({}) do |memo, key|
        memo[key] = attributes[key] unless key == "_id"
        memo
      end
    end

    def update_document
      updates = atomic_updates

      unless updates.empty?
        update_attributes(updates)
      end
    end

    def update_attributes(attrs={})
      selector = {"_id" => id}
      self.class.collection.find(selector).update(attrs)
    end
  end
end
