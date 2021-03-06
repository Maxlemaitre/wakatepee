Rails.application.routes.draw do
  mount Attachinary::Engine => "/attachinary"
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :projects, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    resources :milestones, only: [:create]
    resources :user_projects, only: [:new, :create]
    resources :sub_milestones, only: [:create, :update]
  end
  resources :sub_milestones, only: :destroy do
    resources :comments, only: [:create]
  end

  resources :milestones, only: [:update, :destroy]

end

