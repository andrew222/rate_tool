class PasswordResetsController < ApplicationController
  before_filter :destroy_current_user
  before_filter :require_no_user
  before_filter :load_user_using_perishable_token, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user
      Resque.enqueue(SendEmailJob, @user.id, "deliver_password_reset_instructions!")
      flash[:notice] = t("shared.password_reset_instructions")
      redirect_to root_path
    else
      flash[:error] = t("shared.unable_find_user_by_email", email: params[:email])
      render action: :new
    end
  end

  def update
    @user.password = params[:password]
    @user.password_confirmation = params[:password]
    if @user.save
      flash[:success] = t("shared.update_password_successful")
      redirect_to myaccount_path
    else
      render action: :edit
    end
  end

  def edit
  end

  private

  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:error] = t("shared.unable_find_user")
      redirect_to root_url
    end
  end

  def destroy_current_user
    if current_user
      current_user_session.destroy
    end
  end
end
