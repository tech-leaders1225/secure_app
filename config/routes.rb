Rails.application.routes.draw do
  root   'static_pages#home'
  # static_pageコントローラー
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  post   '/', to: 'static_pages#create' 
  # sessionコントローラー
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  # userコントローラー
  get    '/edit', to: 'users#edit'
  get    '/edit_basic_info' , to: 'users#edit_basic_info'
  patch  '/update_basic_info' , to: 'users#update_basic_info'
  # user>workコントローラー
  get    '/users/working_users'
  # post   '/users/:user_id/works/:id/create_monthwork' , to: 'works#create_monthwork'
  # patch  '/users/:user_id/works/:id/update_monthwork' , to: 'works#update_monthwork'
  # patch  '/users/:user_id/works/:id/update_overwork' , to: 'works#update_overwork'
  # patch  '/users/:user_id/works/:id/update_changework' , to: 'works#update_changework'
  post '/works/redirect_to_show' , to: 'works#redirect_to_show', as: "redirect_to_show"
  


  resources :users do
    collection do
      get  'base_edit'
      post 'base_add'
      patch 'base_update'
      delete 'base_delete'
      get 'base_edit_modal'
    end
    
    member do
      get 'work_log'
      patch  'update_by_admin', as: "update_by_admin"
    end
    
    get 'csv_output'
    resources :works do
      member do
        post 'create_monthwork'
        patch 'create_overwork'
        patch 'update_monthwork'
        patch 'update_overwork'
        patch 'update_changework'
      end
    end
    
  end
  
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]

end