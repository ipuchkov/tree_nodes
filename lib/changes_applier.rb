module ChangesApplier
  class << self
    def apply
      apply_with_id
      apply_without_id
    end

    private

    def apply_with_id
      CachedNode.with_id.each do |node|
        change_node(node)
      end
    end

    def apply_without_id
      CachedNode.without_id.each do |node|
        create_node(node)
      end
    end

    def change_node(node)
      db_node = Node.find(node.id)
      deleted_at = node_deleted_at(node)
      db_node.update_attributes(value: node.value, deleted_at: deleted_at)
    end

    def create_node(node)
      parent_id = node_parent_id(node)
      deleted_at = node_deleted_at(node)
      db_node = Node.create(value: node.value,
                            parent_id: parent_id,
                            deleted_at: deleted_at)
      update_cached_node(node, db_node)
    end

    def update_cached_node(cached_node, db_node)
      cached_node.id       = db_node.id
      cached_node.ancestry = db_node.parent_id
      cached_node.save
    end

    def node_parent_id(node)
      if node.parent_id.match(/\D/)
        node.parent.id
      else
        node.parent_id
      end if node.parent_id.present?
    end

    def node_deleted_at(node)
      node.deleted_at.present? ? node.deleted_at : nil
    end
  end
end
