module SmartAncestry
  class WrongParent < StandardError
  end

  extend ActiveSupport::Concern

  def parent=(record)
    if record.present?
      if record.is_a?(self.class)
        self.ancestry = ancestry_key_for(record)
        self.ancestry_depth = (record.ancestry_depth.to_i + 1).to_s
      else
        raise WrongParent.new(
               "Can`t set ancestry for #{self}
                because parent class is not #{self.class} but #{record.class}")
      end
    elsif record.nil?
      self.ancestry_depth = '0'
    end
  end

  def parent_id
    ancestry
  end

  def parent
    self.class.find(parent_id) || self.class.find_by(:id, parent_id)
  end

  def children
    self.class.all.select do |r|
      r.parent_id.present? && (r.parent_id == self.id || r.parent_id == self.obj_primary_key)
    end
  end

  def child_ids
    children.map(&:uuid)
  end

  private

  def ancestry_key_for(record)
    if has_id?(record)
      record.id
    else
      parent_primary_key(record)
    end
  end

  def has_id?(record)
    record.id.present?
  end

  def parent_primary_key(record)
    key = record.attributes[record.class.primary_key]
    unless key
      raise WrongParent.new(
             "Can`t set ancestry for #{self} because parent not saved")
    end

    key
  end

  # monkey patching base class set_attribute method
  def set_attributes(data_attributes)
    parent = data_attributes.delete(:parent)
    super
    self.parent = parent if parent
  end

  module ClassMethods
    def can_add_root?
      self.deleted_global_roots.any? && global_root.nil?
    end

    def deleted_global_roots
      self.all.select do |r|
        r.ancestry_depth == '0' && r.deleted_at.present?
      end
    end

    def global_root
      self.all.select do |r|
        r.ancestry_depth == '0' && r.deleted_at.blank?
      end.first
    end

    def has_smart_ancestry
      self.attributes << :ancestry << :ancestry_depth
    end
  end
end
