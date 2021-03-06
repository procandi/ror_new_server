Rails.application.routes.draw do
  resources :tabs
  resources :faqs
  resources :contacts
  resources :news

  get 'index_by_title/:id' => 'news#index_by_title'

  get 'index_by_tab/:id' => 'news#index_by_tab'

  get 'index_by_udid/:id' => 'news#index_by_udid'
  
  get 'news/search_by_title/:id' => 'news#search_by_title', as: 'news/search_by_title'
  
  get 'news/search_by_id/:id' => 'news#search_by_id', as: 'news/search_by_id'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root to:'root#home'
  get 'test' => 'root#test'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
  # first in first out endo. @xieyinghua

  

  
  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  resources :users
  get 'search_by_login/:uid/:upw' => 'users#search_by_login'
  post 'search_by_login/:uid/:upw' => 'users#search_by_login'

  resource :session, only: [ :new, :create, :destroy ]

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

  # webservice soap. @xieyinghua
  wash_out :rfid
end
