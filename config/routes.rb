Rails.application.routes.draw do
  resources :nodes, :only => [] do
    post 'add_to_cache', :on => :member
  end

  resources :cached_nodes, :except => [:show, :index]

  get 'reset' => 'application#reset'

  root to: 'application#index'
end
