OpenidSample::Application.routes.draw do
  resource :session
  resource :discovery
  resources :open_ids
  root :to => 'sessions#new'
end
