Dummy::Application.routes.draw do
  root to: "application#welcome"
  get "/my_awesome_blog", to: "blog/posts#index", as: :my_awesome_blog

  namespace :blog do
    resources :posts
    resources :links
  end
end
