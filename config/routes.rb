# Andre Haas, Tom Lai, David Tien

Rails.application.routes.draw do
  # get 'sessions/new'

  root   'users#new'
  get    'signup' => 'users#new'
  get    'login'  => 'sessions#new'
  post   'login'  => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  resources :users

  get 'home'      => 'households#show'
  get  'households/new'   => 'households#new'
  post 'households/create'   => 'households#create'
  post 'households/leave' => 'households#leave'
  post 'households/update' => 'households#update'

  get 'invites' => 'invites#show'
  post 'invites/accept' => 'invites#accept'
  post 'invites/create' => 'invites#create'

  get 'transactions/new_item' => 'transactions#new_item'
  get 'transactions/new_payback' => 'transactions#new_payback'
  get 'transactions/show' => 'transactions#show'
  post 'transactions/create' => 'transactions#create'

  get 'announcements/new' => 'announcements#new'
  get 'announcements/show' => 'announcements#show'
  post 'announcements/create' => 'announcements#create'
  delete 'announcements/destroy' => 'announcements#destroy'

  get 'settings/show' => 'settings#show'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
