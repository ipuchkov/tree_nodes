Rails.application.routes.draw do
  resources :nodes, :only => [] do
    post 'add_to_cache', :on => :member
  end

  root to: 'application#index'
end
