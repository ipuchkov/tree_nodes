class Node < ActiveRecord::Base
  has_ancestry

  scope :deleted,     -> { where.not(:deleted_at => nil) }
  scope :not_deleted, -> { where(:deleted_at => nil) }
end
