Nearness::Application.routes.draw do
  root :to => "frontend#index"

  resources :relations

  resources :things
end
