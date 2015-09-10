class UsersController < ApplicationController
  before_filter :authorize, only: [:show]

  def new
    @user = User.new
  end

  def create
    redirect_to lender_path(@user)
  end

  def show
    @user = current_user
    render :show
  end

  private

  def authorize
    unless current_user
      redirect_to login_path, alert: "Sensei says: 'You are not authorized'"
    end
  end
end
