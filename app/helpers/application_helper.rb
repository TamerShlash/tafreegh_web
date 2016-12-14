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
end
