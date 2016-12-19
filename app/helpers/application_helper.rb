module ApplicationHelper
  def facebook_login_path
    '/auth/facebook'
  end

  def facebook_login_url
    "#{base_url.base_url}#{facebook_login_path}"
  end

  def logged_in?
    @current_user || false
  end

  def admin?
    @current_user.admin? || false
  end

  def approved?
    @current_user.approved? || false
  end
end
