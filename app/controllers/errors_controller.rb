class ErrorsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_and_set_current_person
  skip_verify_authorized

  def not_found
    render status: 404
  end

  def internal_server_error
    render status: 500
  end

  def unprocessable_content
    render status: 422
  end
end
