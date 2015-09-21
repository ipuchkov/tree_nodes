class CachedNode < RedisRecord::Base
  record_columns primary_key: 'uuid', fields: [:id, :value, :ancestry, :deleted_at, :created_at]

  # smart ancestry for redis record
  include SmartAncestry
  has_smart_ancestry

  def deleted?
    self.deleted_at.present?
  end

  def mark_descendants_deleted
    self.descendants.each do |r|
      r.deleted_at = Time.zone.now
      r.save
    end
  end

  def self.with_id
    all.select { |r| r.id.present? }.sort { |a,b| a.ancestry_depth <=> b.ancestry_depth}
  end

  def self.without_id
    all.select { |r| r.id.blank? }.sort { |a,b| a.ancestry_depth <=> b.ancestry_depth}
  end
end
