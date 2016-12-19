class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale, :authenticate!
  rescue_from Errors::AuthenticationError, with: :authentication_required
  rescue_from Errors::AuthorizationError,  with: :unauthorized

  helper_method :current_user

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def authenticate!
    return if current_user
    return if request.headers['Tafreegh-Token'] == ENV.fetch('TAFREEGH_TOKEN')
    raise Errors::AuthenticationError
  end

  def authentication_required
    redirect_to login_path, alert: t('users.login_required')
  end

  def unauthorized
    redirect_to dashboard_path, alert: t('uesrs.unauthorized')
  end

  protected

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
