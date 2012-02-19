Nearness::Application.routes.draw do
  root :to => "frontend#index"

  resources :relations
  resources :things

  match "rels(;:predicate)(.:our_format)/*url" => "things_profile#relations"
  match "(.:our_format/)*url"                  => "things_profile#show"
end
