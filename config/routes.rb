Rails.application.routes.draw do

  devise_for :users

  authenticate :user do
    resource :product_list, only: [:edit, :update]

    resource :profile, only: [:edit, :update]

    resources :dealerships do
      resource :product_list, only: [:edit, :update]

      resources :users
    end

    resources :deals do
      resource :product_list, only: [:edit, :update]
      resource :worksheet, only: [:show, :update]
    end
  end

  authenticated :user do
    root to: 'dealerships#index', as: :admin_root, constraints: ->(req) { req.env['warden'].user.try(:admin?) }
    root to: 'deals#index', as: :financial_manager_root, constraints: ->(req) { req.env['warden'].user.try(:financial_manager?) }
  end

  root 'landing#index'
end
