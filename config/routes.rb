Rails.application.routes.draw do

  devise_for :users

  authenticate :user do
    resources :dealerships, except: :show do
      resources :users
      resource :product_list, only: [:edit, :update]
    end

    resources :deals do
      resource :product_list, only: [:edit, :update]
      resource :worksheet, only: [:show, :update]
      resources :options, only: [:show, :update]
    end

    resource :profile, only: [:edit, :update]
    resource :product_list, only: [:edit, :update]
  end

  authenticated :user do
    root to: 'dealerships#index', as: :admin_root, constraints: ->(req) { req.env['warden'].user.try(:admin?) }
    root to: 'deals#index', as: :financial_manager_root, constraints: ->(req) { req.env['warden'].user.try(:financial_manager?) }
  end

  root 'landing#index'
end