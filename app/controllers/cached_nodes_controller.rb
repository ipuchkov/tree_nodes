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
      render_list
    else
      make_flash('Node not saved')
    end
  end

  def new
    if params[:parent_id].present? || CachedNode.can_add_root?
      @cached_node = CachedNode.new
      render :new, layout: false
    else
      return head(:forbidden)
    end
  end

  def create
    @cached_node = CachedNode.new
    @cached_node.value = params[:value]

    parent = CachedNode.find(params[:parent_id])
    @cached_node.parent = parent

    if @cached_node.save
      render_list
    else
      make_flash('Node not created')
    end
  end

  def destroy
    @cached_node = CachedNode.find(params[:id])
    @cached_node.deleted_at = Time.zone.now.to_s
    if @cached_node.save
      @cached_node.mark_descendants_deleted
      render_list
    else
      make_flash('Can`t delete node')
    end
  end

  private

  def make_flash(message)
    flash[:notice] = message
    render nothing: true
  end

  def render_list
    @cached_nodes = TreeForRender.new.build_tree
    render partial: 'cached_nodes/list', locals: { cached_nodes: @cached_nodes }
  end
end
