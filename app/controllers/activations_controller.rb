class ActivationsController < ApplicationController
  before_filter :require_no_user, only: [:new, :create]
  def new
    @user = User.find_by_perishable_token(params[:activation_code]) || (raise Exception)
    raise Exception if @user.active?
  end

  def create
    @user = User.find(params[:id])
    return if @user.active?

    if @user.activate!
      SendEmailJob.perform_async(@user.id, "deliver_activation_confirmation!")
      redirect_to myaccount_path
    else
      render :new
    end
  end
end
