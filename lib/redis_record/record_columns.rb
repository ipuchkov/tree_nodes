module RedisRecord
  module RecordColumns
    extend ActiveSupport::Concern

    module ClassMethods
      def record_columns(primary_key: 'id', fields: [])
        class_attribute :primary_key, :fields, :attributes
        self.primary_key = primary_key.to_sym
        self.fields = fields
        self.attributes = [primary_key.to_sym] + fields
      end
    end
  end
end
