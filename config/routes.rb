Rails.application.routes.draw do
  resources :grupos
  resources :selecciones

  get "up" => "rails/health#show", as: :rails_health_check
  root "grupos#index"
end
