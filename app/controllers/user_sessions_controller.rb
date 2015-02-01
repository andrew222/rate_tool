class UserSessionsController < ApplicationController
  before_filter :require_no_user, only: [:new, :create]
  before_filter :require_user, only: :destroy

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(user_params)
    if @user_session.save
      flash[:notice] = t("user_sessions.login_successful")
      redirect_to myaccount_path
    else
      render :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = t("user_sessions.logout_successful")
    redirect_to root_path
  end

  private
    def user_params
      params.require(:user_session).permit(:email, :password)
    end
end
