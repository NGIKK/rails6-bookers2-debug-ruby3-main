Rails.application.routes.draw do
  get 'rooms/show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "homes#top"
  get "home/about"=>"homes#about"
  devise_for :users
  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorites,only: [:create,:destroy]
    #resourceが単数形だと、自身のidをurlに含めなくなる。
    #他のモデルのidでfavoriteのidも特定できるため、favoriteのidは
    resources :book_comments,only: [:create, :destroy]
    end

  resources :users, only: [:index,:show,:edit,:update] do
   resource :relationships, only: [:create, :destroy]
   get 'followings' => 'relationships#followings', as: 'followings'
   get 'followers' => 'relationships#followers', as: 'followers'
  end

  resources :messages, only: [:show, :create]

  get 'search' => 'searches#search'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end