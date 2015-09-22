class CachedNodesController < ApplicationController
  respond_to :js

  before_filter :check_value, only: [:create, :update]

  def edit
    @cached_node = CachedNode.find(params[:id])
    render :edit, layout: false
  end

  def update
    @cached_node = CachedNode.find(params[:id])
    @cached_node.value = params[:value]
    make_flash('Node not saved') unless @cached_node.save
    render_list
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

    make_flash('Node not created') unless @cached_node.save
    render_list
  end

  def destroy
    @cached_node = CachedNode.find(params[:id])
    @cached_node.deleted_at = Time.zone.now.to_s
    if @cached_node.save
      @cached_node.mark_descendants_deleted
    else
      make_flash('Can`t delete node')
    end
    render_list
  end

  private

  def check_value
    unless params[:value].present?
      make_flash('Value cant be blank')
      flash_to_headers
      render_list
    end
  end

  def make_flash(message)
    flash[:notice] = message
  end

  def render_list
    @cached_nodes = TreeForRender.new.build_tree
    render partial: 'cached_nodes/list', locals: { cached_nodes: @cached_nodes }
  end
end
