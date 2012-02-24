Nearness::Application.routes.draw do
  root :to => "things_profile#index"

  resources :relations
  resources :things
 
  match "(.:our_format)"                  => "things_profile#index",      :as => :thing_profile
  post  "rels"                                 => "things_profile#create_relation", :as => :create_relation
  match "rels(;:predicate)(.:our_format)/*url" => "things_profile#relations", :as => :thing_profile_relations  
  match "(.:our_format/)*url"                  => "things_profile#show",      :as => :thing_profile
  match "things(.:our_format/)*url"            => "things_profile#show",      :as => :thing_profile 
end

