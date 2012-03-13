Nearness::Application.routes.draw do
  match "/bookmarklet" => "frontend#bookmarklet"
  # internal things api
  match "things(.:format)"    => "things_profile#index",      :as => :thing_profile 

  # official api
  match "/http%3A%2F%2F*url_part/*predicate_format(.:format)" => "things_profile#relations",       :as => :thing_profile
  match "/http%3A%2F%2F*url_part"            => "things_profile#thing",           :as => :thing_profile
  post "/"                                   => "things_profile#create_relation", :as => :thing_profile

  match "/*url"               => "frontend#index"
  root :to => "frontend#index"
end

