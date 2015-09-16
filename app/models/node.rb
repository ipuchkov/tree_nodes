class Node < ActiveRecord::Base
  has_ancestry :cache_depth => true

  scope :deleted,     -> { where.not(:deleted_at => nil) }
  scope :not_deleted, -> { where(:deleted_at => nil) }

  def for_cache
    self.as_json(only: [:id, :value, :ancestry, :ancestry_depth, :deleted_at])
  end
end
