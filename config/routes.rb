Rails.application.routes.draw do
  resources :application, controller: :applications, param: :token do
    resources :chat, controller: :chats, param: :no do
      resources :message, controller: :messages, param: :message_no
      get 'messages/search' => 'messages#search'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
