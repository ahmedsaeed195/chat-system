class ApplicationsController < ApplicationController
  before_action :set_application, only: %i[show update destroy]

  def index
    @applications = Application.all
    applications = []
    @applications.map do |application|
      app = modify_application(application.attributes)
      applications.push(app)
    end
    render json: applications
  end

  def show
    if @application
      application = modify_application(@application.attributes)
      render json: application
    else
      render json: { error: 'Not Found' }, status: 404
    end
  end

  def create
    token = set_token
    data = { token: token, name: application_params[:name] }
    @application = Application.new(data)
    if @application.save
      application = modify_application(@application.attributes)
      render json: application, status: :created
    else
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  def update
    if @application.update(application_params)
      application = modify_application(@application.attributes)
      render json: application
    else
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @application
      @application.destroy
      render json: { message: 'Successfully deleted' }
    else
      render json: { error: 'Not Found' }, status: 404
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_application
    @application = Application.find_by_token(params[:token])
  end

  def set_token
    token = ''
    loop do
      token = SecureRandom.base58(32) # check token uniqueness
      break unless Application.find_by_token(token)
    end
    token
  end

  def modify_application(application)
    application = application.except('id')
    application.slice!('application_no')
  end

  # Only allow a list of trusted parameters through.
  def application_params
    params.require(:application).permit(:name)
  end
end
