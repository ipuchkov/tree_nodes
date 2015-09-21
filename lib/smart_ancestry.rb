module SmartAncestry
  class WrongParent < StandardError
  end

  extend ActiveSupport::Concern

  def parent=(record)
    if record.present?
      if record.is_a?(self.class)
        value = ancestry_value(record)
        self.ancestry = value
        self.ancestry_depth = value.split(/\//).count.to_s
      else
        raise WrongParent.new("Can`t set ancestry for #{self} because parent class is not #{self.class} but #{record.class}")
      end
    end
  end

  def parent_id
    ancestry_ids.last
  end

  def parent
    self.class.find(parent_id) || self.class.find_by(:id, parent_id)
  end

  def children
    self.class.all.select {|r| r.parent_id == self.id || r.parent_id == self.obj_primary_key }
  end

  def child_ids
    children.map(&:uuid)
  end

  def descendants
    self.class.all.select do |r|
      r.ancestry_ids.include?(self.uuid) || r.ancestry_ids.include?(self.id)
    end
  end

  def root_id
    ancestry_ids.first
  end

  def ancestry_ids
    ancestry.split(/\//)
  end

  private

  def ancestry_value(record)
    ancestry_key = ancestry_key_for(record)

    if record.ancestry.present?
      record.ancestry + "/#{ancestry_key}"
    else
      ancestry_key.to_s
    end
  end

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
    raise WrongParent.new("Can`t set ancestry for #{self} because parent not saved") unless key

    key
  end

  # monkey patching base class set_attribute method
  def set_attributes(data_attributes)
    parent = data_attributes.delete(:parent)
    super
    self.parent = parent if parent
  end

  module ClassMethods
    def has_smart_ancestry
      self.attributes << :ancestry << :ancestry_depth
    end
  end
end
