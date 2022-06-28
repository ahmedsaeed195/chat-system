class MessagesController < ApplicationController
  before_action :set_chat
  before_action :set_message, only: %i[show update destroy]
  before_action :set_message_no, only: [:create]
  def index
    @messages = Message.where(chat_id: @chat.id)
    messages = []
    @messages.map do |message|
      c = modify_message(message.attributes)
      messages.push(c)
    end
    render json: messages
  end

  def show
    message = modify_message(@message.attributes)
    render json: message
  end

  def search
    puts params[:content].present?
    @messages = Message.search(query: { query_string: { default_field: 'content',
                                                        query: "*#{params[:content]}*" } }).records
    messages = []
    @messages.map do |message|
      c = modify_message(message.attributes)
      messages.push(c)
    end
    render json: messages
  end

  def create
    data = { sender: message_params[:sender], content: message_params[:content], message_no: @message_no,
             chat_id: @chat.id }
    @message = Message.new(data)
    if @message.save
      message = modify_message(@message.attributes)
      render json: message, status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  def update
    if @message.update(message_params)
      message = modify_message(@message.attributes)
      render json: message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @message.destroy
    render json: { message: 'Successfully deleted' }
  end

  private

  def set_chat
    @application = Application.find_by_token(params[:application_token])
    return render json: { error: 'Application Not Found' }, status: 404 unless @application

    @chat = Chat.find_by(chat_no: params[:chat_no], application_id: @application.id)
    render json: { error: 'Chat Not Found' } unless @chat
  end

  def set_message
    @message = Message.find_by_chat_id(@chat.id)
    render json: { error: 'Message Not Found' } unless @message
  end

  def modify_message(message)
    message = message.except('id', 'chat_id')
    remainder = message.slice!('message_no')
    message[:chat_no] = @chat.chat_no
    message[:application_token] = @application.token
    message.merge(remainder)
  end

  def set_message_no
    messages = Message.where(chat_id: @chat.id)
    @message_no = if messages.length.zero?
                    1
                  else
                    messages.last[:message_no] + 1
                  end
  end

  def message_params
    params.require(:message).permit(:sender, :content)
  end
end
