Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #Routing concerns allow you to declare common routes that can be reused inside other resources and routes. 
  #To define a concern, see https://edgeguides.rubyonrails.org/routing.html#routing-concerns
  concern :api_base do
    resources :applications, param: :token, only: [:create, :show, :update] do
      #add search endpoint, 
      #Note: added search route in this level for rename :number (in controller was chat_number when added in second level `chats loop`)
      get "/chats/:number/search", to: "chats#search"
      resources :chats, param: :number, only: [:create, :show] do
        #Note: as no field need to be updated by client So, ingnoring :update route in chat level
        resources :messages, param: :number, only: [:create, :show, :update]
        # get "/count", to: "messages#count"
      end
    end
  end

  #For sidekiq dashboard
  # If this is a Rails app in API mode, 
  #     you need to enable sessions. https://guides.rubyonrails.org/api_app.html#using-session-middlewares
  # require 'sidekiq/web'
  # mount Sidekiq::Web => "/sidekiq"

  #api
  namespace :api do
    namespace :v1 do
      concerns :api_base
    end
  end
end
