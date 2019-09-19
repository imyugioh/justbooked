require 'sidekiq/web'

Rails.application.routes.draw do
  resources :reviews, only: [:index, :show]
  put 'purchase/charge'
  put 'purchase/charge_back'
  post 'reviews/save_review' => 'reviews#save_review', as: :save_review

  default_url_options host: ENV['HOST']

  get "/invites/:provider/contact_callback" => "invites#index"
  get "/contacts/failure" => "invites#failure"

  # TODO: Delete after email invitation test
  get "/invite_test" =>  "invites#index"
  get '/chefs/get_index/' => 'chefs#get_index', as: :get_index
  get "/pages/:page" => "pages#show"
  
  get 'cart/:id/:chef_id', to: 'cart#show'
  resources :listings, only:  [:index, :show]
  resources :chefs, only:  [:index, :show]
  resources :chef_signup
  resources :menus
  resources :invites, only:  [:index, :create]
  resources :newsletters, only:  [:index, :create]
  resources :messages, only: [:new, :create]

  resource :payment, only: [:create] do
    get :index
    get :success
    get :fail
  end

  resources :notifications, only:  [:index, :show]

  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :skip => [:registrations]
  ActiveAdmin.routes(self)

  namespace :admin do
    mount Sidekiq::Web, at: '/sidekiq'
  end


  devise_for :users, controllers: {
    registrations: 'api/users/registrations',
    confirmations: 'api/users/confirmations',
    passwords: 'api/users/passwords',
    sessions: 'api/users/sessions',
  }

  # devise_scope :api do
  #   get 'sign_out', to: 'api/users/sessions/destroy'
  # end

  root 'welcome#index'


  resources :signup, only: [:index, :create]

  get '/promo' => 'signup#index'
  get '/history' => 'welcome#history'
  get '/blog' => 'blog#index'
  get '/blog/articles/:id' => 'blog#show', as: :article
  get '/about' => 'welcome#about'
  get '/mail-list' => 'welcome#mail_list', as: :mail_list
  get '/terms-and-privacy' => 'welcome#terms_and_privacy', as: :terms_and_privacy

  get 'beta', to: 'venues#index', as: :specials
  get '/promo' => 'signup#index'
  post '/promp' => 'signup#create', as: :promo_signup

  get 'orders/order_details/:id', to: 'orders#order_details', as: :order_details
  get 'orders/token_order_details/:id/:token', to: 'orders#token_order', as: :token_order
  get '/orders' => 'orders#index', as: :order_index


  resource :account do
    get 'settings'
    get 'payment_settings'
    put 'payment_update'
    put 'save_password'
    get 'password'
    get 'listings'
    get 'newsletter'
    get 'certification'
    put 'save_certification_documents'
  end

  namespace :api do
    resources :search, only: [:index] do
      collection do
        get :filters
      end
    end
    resources :cart, only: [:show]
    resources :coupons, only: [:show]
    resources :locations, except: [:show] do
      collection do
        get :all_states
        get :cities
        get :cities_with_states
        get :states
      end
    end
    # get 'locations/cities' => 'locations#cities'
    # get 'locations/cities_with_states' => 'locations#cities_with_states'
    # get 'locations/states' => 'locations#states'
    get '/user' => 'users#user_info'
    resources :search_options do
      collection do
        get :all_menu_types
        get :menu_types
        get :event_types
        get :amenities
        get :article_tags
        get :food_items
      end
    end
    resources :assets
    # resources :accounts do
    #   member do
    #     put :update_account
    #     put :personal
    #     put :business
    #     put :address
    #     put :terms_of_service
    #     put :bank_account
    #     get :bank_account
    #     delete :bank_account
    #   end
    # end
    resources :mail_lists, only: :create
    resources :feedbacks, only: :create
    resources :notifications, only: [:index, :destroy] do
      member do
        put :mark_as_read
      end
      collection do
        put :mark_all_as_read
      end
    end
    resources :comments
    resources :reviews, only: [:index, :create]
    resources :users do
      collection do
        get :cards
      end
      member do
        put :update_password
      end
    end
    # resources :menus do
    #   member do
    #     get :dashboard
    #     post :favorites_toggle
    #     post :redeem
    #   end
    #   collection do
    #     get 'recent'
    #   end
    # end

    delete '/assets/:id/delete_venue_asset' => 'assets#delete_venue_asset', as: :delete_venue_asset

    get '/assets/home_app.js.map', :to => redirect('/assets/javascripts/home_app.js.map')
    get '/assets/listing_app.js.map', :to => redirect('/assets/javascripts/listing_app.js.map')
    get '/assets/carts_app.js.map', :to => redirect('/assets/javascripts/carts_app.js.map')

    resources :menus, only: [:show] do
    end

  end

  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all

end
