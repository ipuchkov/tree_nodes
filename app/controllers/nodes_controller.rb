class NodesController < ApplicationController
  respond_to :js

  def add_to_cache
    id = params[:id]

    if CachedNode.find_by(:id, id).present?
      flash[:alert] = "Запись уже помещена в КЭШ"
    else
      @node = Node.find(params[:id])
      @cached_node = CachedNode.new(@node.for_cache).save

      render nothing: true
    end
  end
end
