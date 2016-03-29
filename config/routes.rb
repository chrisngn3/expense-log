Rails.application.routes.draw do
  root 'pages#welcome'

  # Expense
  get '/expenses' => 'expenses#index'
  get '/expenses/new' => 'expenses#new'
  post '/expenses' => 'expenses#create'

  # We name this route "expense" and Rails will create a helper method called "expense_path"
  get '/expenses/:id' => 'expenses#show', as: :expense
  delete '/expenses/:id' => 'expenses#destroy'

  # Currently edit is disabled
  get '/expenses/:id/edit' => 'expenses#edit', as: :edit_expense
  patch '/expenses/:id' => 'expenses#update'
  

  # User
  get '/users' => 'users#index'
  get '/users/new' => 'users#new'
  post '/users' => 'users#create'
  get '/users/:id' => 'users#show', as: :user
  delete '/users/:id' => 'users#destroy'

  # Currently editing user is diabled
  get '/users/:id/edit' => 'users#edit', as: :edit_user
  patch '/users/:id' => 'users#update'

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
