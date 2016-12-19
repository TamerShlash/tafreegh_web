class User < ApplicationRecord
  has_many :videos, before_add: :set_assigned_date, before_remove: :remove_assigned_date

  class << self
    def from_omniauth(auth)
      puts auth
      User.find_or_initialize_by(fbid: auth.uid) do |user|
        user.fbid = auth.uid
        user.name = auth.info.name
        user.email = auth.info.email
        user.oauth_token = auth.credentials.token
        user.oauth_expires_at = Time.at(auth.credentials.expires_at)
        user.save!
      end
    end
  end

  def current_video
    @current_video ||= videos.where(transcribed: false).order(assigned_at: :desc).first
  end

  def completed_videos
    videos.where(transcribed: true)
  end

  def can_assign?
    current_video.blank?
  end

  def set_assigned_date(video)
    video.assigned_at = Time.now.utc
  end

  def remove_assigned_date(date)
    video.assigned_at = nil
  end
end
