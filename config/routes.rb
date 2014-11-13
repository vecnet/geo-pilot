Rails.application.routes.draw do
  get 'download/file/:id' => 'download#file', as: :download_file
  resources :download, only: [:show, :file]
  post "wms/handle"
  root :to => "catalog#index"
  blacklight_for :catalog
  devise_for :users
end
