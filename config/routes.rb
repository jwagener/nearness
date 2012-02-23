Nearness::Application.routes.draw do
  root :to => "frontend#index"

  resources :relations
  resources :things
 
  post "rels" => "things_profile#create_relation", :as => :create_relation
  match "rels(;:predicate)(.:our_format)/*url" => "things_profile#relations", :as => :thing_profile_relations  
  match "(.:our_format/)*url"                  => "things_profile#show",      :as => :thing_profile
end
