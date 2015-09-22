class CachedNode < RedisRecord::Base
  record_columns primary_key: 'uuid',
                 fields: [:id, :value, :ancestry, :deleted_at, :created_at]

  # smart ancestry for redis record
  include SmartAncestry
  has_smart_ancestry

  def deleted?
    self.deleted_at.present?
  end

  def mark_descendants_deleted
    self.children.each do |r|
      r.deleted_at = Time.zone.now
      r.save
      r.mark_descendants_deleted if r.children.any?
    end
  end

  def self.with_id
    all.select { |r| r.id.present? }.sort do |a,b|
      a.ancestry_depth <=> b.ancestry_depth
    end
  end

  def self.without_id
    all.select { |r| r.id.blank? }.sort do |a,b|
      comp = a.ancestry_depth <=> b.ancestry_depth
      comp = a.id.presence.to_i <=> b.id.presence.to_i if comp.zero?
      comp = a.created_at <=> b.created_at if comp.zero?
      comp
    end
  end
end
