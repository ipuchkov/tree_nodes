class Node < ActiveRecord::Base
  has_ancestry :cache_depth => true

  after_save :mark_descendants_deleted, if: -> { self.deleted_at.present? }

  scope :deleted,     -> { where.not(deleted_at: nil) }
  scope :not_deleted, -> { where(deleted_at: nil) }

  def for_cache
    self.as_json(only: [:id, :value, :ancestry, :ancestry_depth, :deleted_at])
  end

  def deleted?
    self.deleted_at.present?
  end

  private

  def mark_descendants_deleted
    descendants.update_all(deleted_at: Time.zone.now)
  end
end
