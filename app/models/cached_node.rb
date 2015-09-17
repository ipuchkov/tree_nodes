class CachedNode < RedisRecord::Base
  record_columns primary_key: 'uuid', fields: [:id, :value, :ancestry, :deleted_at, :created_at]

  # smart ancestry for redis record
  include SmartAncestry
  has_smart_ancestry
end
