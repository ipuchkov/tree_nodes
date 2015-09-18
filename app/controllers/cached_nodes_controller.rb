class CachedNodesController < ApplicationController
  respond_to :js

  def edit
    @cached_node = CachedNode.find(params[:id])
    render :edit, layout: false
  end

  def update
    @cached_node = CachedNode.find(params[:id])
    @cached_node.value = params[:value]
    if @cached_node.save
      @cached_nodes = TreeForRender.new.build_tree
      render partial: 'cached_nodes/list', locals: { cached_nodes: @cached_nodes }
    else
      flash[:notice] = 'Node not saved'
      render nothing: true
    end
  end
end
