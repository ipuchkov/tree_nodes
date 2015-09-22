require 'rake'
TreeNodes::Application.load_tasks
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  after_filter :flash_to_headers

  def index
    @roots = Node.at_depth(0).order(:id)
    @cached_nodes = TreeForRender.new.build_tree
  end

  def apply
    ChangesApplier.apply
    flash[:notice] = 'All changes were saved to database'
    redirect_to root_path
  end

  def reset
    Rake::Task['db:schema:load'].reenable
    Rake::Task['db:schema:load'].invoke
    Rake::Task['db:seed'].reenable
    Rake::Task['db:seed'].invoke
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
