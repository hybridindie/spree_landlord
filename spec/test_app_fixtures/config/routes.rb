Rails.application.routes.draw do
  mount Spree::Core::Engine => "/"

  match 'views/:view_name' => 'views#show'
end
