class SessionsController < ApplicationController
  skip_before_action :authenticate!

  def new
  end

  def create
    puts fbid_whitelist
    puts request.env['omniauth.auth']
    unless fbid_whitelist.include? request.env['omniauth.auth'].info.name
      redirect_to login_path, alert: t('users.not_whitelisted')
      return
    end
    user = User.from_omniauth(request.env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to root_path, notice: t('users.login_successful')
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: t('users.logout_successful')
  end

  def fbid_whitelist
    ENV['FACEBOOK_WHITELIST'].split(',')
  end
end
