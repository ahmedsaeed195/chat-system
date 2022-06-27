class ChatsController < ApplicationController
  before_action :set_application
  before_action :set_chat, only: %i[show update destroy]
  before_action :set_chat_no, only: [:create]

  def index
    @chats = Chat.where(application_id: @application.id)
    chats = []
    @chats.map do |chat|
      c = modify_chat(chat.attributes)
      chats.push(c)
    end
    render json: chats
  end

  def show
    chat = modify_chat(@chat.attributes)
    render json: chat
  end

  def create
    data = { chat_no: @chat_no, application_id: @application.id }
    @chat = Chat.new(data)
    if @chat.save
      chat = modify_chat(@chat.attributes)
      render json: chat, status: :created
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  def update
    @application = Application.find_by_token(chat_params[:app_token]) if chat_params[:app_token]
    return render json: { error: 'Chat Already Exists' } if Chat.find_by(chat_no: chat_params[:chat_no],
                                                                         application_id: @application.id)

    data = { chat_no: chat_params[:number], application_id: @application.id }
    if @chat.update(data)
      chat = modify_chat(@chat.attributes)
      render json: chat
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @chat.destroy
    render json: { message: 'Successfully deleted' }
  end

  private

  def set_application
    @application = Application.find_by_token(params[:application_token])
    render json: { error: 'Application Not Found' }, status: 404 unless @application
  end

  def set_chat
    @chat = Chat.find_by(chat_no: params[:number], application_id: @application.id)
    render json: { error: 'Chat Not Found' } unless @chat
  end

  def modify_chat(chat)
    chat = chat.except('id', 'application_id')
    remainder = chat.slice!('chat_no')
    chat[:application_token] = @application.token
    chat.merge(remainder)
  end

  def set_chat_no
    chats = Chat.where(application_id: @application.id)
    @chat_no = if chats.length.zero?
                 1
               else
                 chats.last[:chat_no] + 1
               end
  end

  # Only allow a list of trusted parameters through.
  def chat_params
    params.slice('app_token', 'number')
  end
end
