class UsersController < ApplicationController
  before_filter :require_no_user, only: [:new, :create]
  before_filter :require_user, only: [:show, :edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = t("shared.signup_successful")
      Resque.enqueue(SendEmailJob, @user.id, "deliver_activation_instructions!")
      flash[:notice] = "请先激活账号。"
      redirect_to root_path
    else
      render :new
    end
  end
  def edit
    @user = current_user
  end

  def show
    @user = current_user
    @settings = @user.settings
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
