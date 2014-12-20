Krikri::Engine.routes.draw do
  # TODO: remove unnecessary :harvest_sources and :institutions routes once we
  # have established what we do and don't need
  resources :harvest_sources
  resources :institutions
  resources :validation_reports, only: [:index]
end
