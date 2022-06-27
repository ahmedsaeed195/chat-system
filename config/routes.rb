Rails.application.routes.draw do
  resources :application, controller: :applications, param: :token do
    resources :chat, controller: :chats, param: :chat_no
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
