class SessionsController < ApplicationController
  skip_before_action :authenticate!

  def new
  end

  def create
    @current_user = User.from_omniauth(request.env['omniauth.auth'])
    session[:user_id] = @current_user.id
    redirect_to root_path, notice: t('users.login_successful')
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: t('users.logout_successful')
  end
end
