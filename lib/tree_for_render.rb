class TreeForRender
  def build_tree
    reverse_sorted_nodes.each do |node|
      id = id_for(node)
      parent_id = node.parent_id
      if parent_in_tree?(parent_id)
        prepared_tree_hash[parent_id][:children].merge!(id => prepared_tree_hash.delete(id))
      end
    end

    prepared_tree_hash
  end

  private

  def id_for(node)
    node.id.presence || node.uuid
  end

  def parent_in_tree?(id)
    prepared_tree_hash.has_key?(id)
  end

  def prepared_tree_hash
    @tree_hash ||= sorted_nodes.inject({}) do |h, n|
      key = n.id.present? ? n.id : n.uuid
      h.merge!(key => {obj: n, children: {}})
    end
  end

  def nodes
    @nodes ||= CachedNode.all
  end

  def sorted_nodes
    @sorted_nodes ||= nodes.sort do |a,b|
      comp = a.ancestry_depth <=> b.ancestry_depth
      comp = a.id.presence.to_i <=> b.id.presence.to_i if comp.zero?
      comp = -1*(a.created_at <=> b.created_at) if comp.zero?
      comp
    end
  end

  def reverse_sorted_nodes
    @reverse_sorted_nodes ||= nodes.sort do |a,b|
      comp = -1*(a.ancestry_depth <=> b.ancestry_depth)
      comp = a.id.to_i <=> b.id.to_i if comp.zero? && a.id.presence && b.id.presence
      comp = a.created_at <=> b.created_at if comp.zero?
      comp
    end
  end
end
