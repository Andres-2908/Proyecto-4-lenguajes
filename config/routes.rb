Rails.application.routes.draw do
  resources :grupos
  resources :selecciones
  resources :partidos, only: [:index, :edit, :update] do
    post :generar_fase_grupos, on: :collection
  end

  get "eliminatoria", to: "eliminatoria#show"
  post "eliminatoria/generar", to: "eliminatoria#generar", as: :generar_eliminatoria
  get "eliminatoria/podio", to: "eliminatoria#podio", as: :podio_eliminatoria

  get "up" => "rails/health#show", as: :rails_health_check
  root "grupos#index"
end
