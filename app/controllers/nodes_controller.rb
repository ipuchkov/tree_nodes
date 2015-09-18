class NodesController < ApplicationController
  respond_to :js

  def add_to_cache
    id = params[:id]

    if CachedNode.find_by(:id, id).present?
      flash[:notice] = "Node is already added"
      render nothing: true
    else
      @node = Node.find(params[:id])
      @cached_node = CachedNode.new(@node.for_cache)
      if @cached_node.save
        @cached_nodes = TreeForRender.new.build_tree
      else
        flash[:notice] = "Node is not saved"
        render nothing: true
      end
    end
  end
end
