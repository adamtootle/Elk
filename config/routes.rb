Elk::Application.routes.draw do

  get "build_uploads/new"

  put '/apps/reorder' => 'apps#update_apps_order', :as => :apps_order

  resources :builds
  resources :apps

  get '*\.mobileconfig' => 'xml#mobileconfig'
  get '/build-:id.plist' => 'xml#plist'
  post 'register_device' => 'xml#register_device'
  post '/builds/upload' => 'build_uploads#new'
  get '/apps/:id/builds/new' => 'builds#new', :as => :new_app_build
  get '/apps/:id/builds/:build_id' => 'builds#show', :as => :app_build
  get '/apps/:id/users' => 'apps#users', :as => :app_users
  post '/apps/:id/users' => 'apps#new_user', :as => :new_app_user
  delete '/apps/:id/users/:user_id' => 'apps#delete_user', :as => :delete_app_user
  get '/apps/:id/lists' => 'apps#distribution_lists', :as => :app_distribution_lists
  post '/apps/:id/lists' => 'apps#new_distribution_list', :as => :new_app_distribution_list
  post '/apps/:id/lists/users' => 'apps#new_dist_list_user', :as => :new_dist_list_user
  delete '/apps/:app_id/lists/:list_id/users/:user_id' => 'apps#delete_dist_list_user', :as => :delete_dist_list_user
  delete '/apps/:app_id/lists/:list_id' => 'apps#delete_dist_list', :as => :delete_dist_list
  delete '/devices/:id' => 'devices#destroy', :as => :destroy_device

  devise_for :users, :skip => [:sessions]
  as :user do
    get 'login' => 'devise/sessions#new', :as => :new_user_session
    post 'login' => 'devise/sessions#create', :as => :user_session
    get 'logout' => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  root :to => redirect('/apps')

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
