class TosAgreementsController < ApplicationController
  before_action :set_user, only: %i[edit update]

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to root_path, notice: "Success"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:tos_agreement)
  end

  def set_user
    @user = current_user

    authorize! @user
  end
end
