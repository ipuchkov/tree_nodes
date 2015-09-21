class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  after_filter :flash_to_headers

  def index
    @root = Node.not_deleted.find_by(:ancestry => nil)
    @cached_nodes = TreeForRender.new.build_tree
  end

  def reset
    %x(bundle exec rake db:schema:load db:seed)
    CachedNode.destroy_all
    flash[:notice] = 'All data were reseted to initial state'
    redirect_to root_path
  end

  private

  def flash_to_headers
    return unless request.xhr?
    if (message = flash_message)
      response.headers['X-Message'] = message
      response.headers["X-Message-Type"] = flash_type.to_s

      flash.discard
    end
  end

  def flash_message
    [:error, :warning, :notice].each do |type|
      return flash[type] unless flash[type].blank?
    end

    nil
  end

  def flash_type
    [:error, :warning, :notice].each do |type|
      return type unless flash[type].blank?
    end

    nil
  end
end
