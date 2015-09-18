class TreeForRender
  def build_tree
    reverse_sorted_nodes.each do |node|
      id = id_for(node)
      ancestries = ancestries_for(node)

      ancestries.each do |anc|
        if parent_in_tree?(anc)
          prepared_tree_hash[anc][:children].merge!(id => prepared_tree_hash.delete(id))
          break
        end
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

  def ancestries_for(node)
    node.ancestry.split(/\//).reverse
  end

  def prepared_tree_hash
    @tree_hash ||= sorted_nodes.inject({}) do |h, n|
      key = n.id.present? ? n.id : n.uuid
      h.merge!(key => {:obj => n, :children => {}})
    end
  end

  def nodes
    @nodes ||= CachedNode.all
  end

  def sorted_nodes
    @sorted_nodes ||= nodes.sort do |a,b|
      a.ancestry_depth <=> b.ancestry_depth && a.created_at <=> b.created_at
    end
  end

  # FIXME fix sorting
  def reverse_sorted_nodes
    @reverse_sorted_nodes ||= nodes.sort do |a,b|
      b.ancestry_depth <=> a.ancestry_depth
    end
  end
end
