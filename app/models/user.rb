class User < ApplicationRecord
  def self.from_omniauth(auth)
    User.find_or_create_by!(fbid: auth.uid) do |user|
      user.fbid = auth.uid
      user.name = auth.info.name
      user.email = auth.info.email
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
    end
  end
end
