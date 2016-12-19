class VideosController < ApplicationController
  include VideosHelper

  before_action :set_video, only: [:show, :assign, :transcription]
  before_action :authorize!, except: [:auto_transcription, :transcription, :need_transcription, :show, :assign]
  protect_from_forgery except: [:auto_transcription]

  # GET /videos
  def index
    @videos = Video.everything
  end

  # GET /videos/1
  def show
    unless uploadable?(@video) || assignable?(@video)
      raise Errors::AuthorizationError
    end
  end

  # GET /videos/new
  def new
  end

  # POST /videos
  def create
    YoutubeFetcher.new(params.require(:yt_urls)).fetch!
    redirect_to videos_path, notice: t('videos.successfully_added')
  rescue Errors::TooManyVideosError
    flash.now[:alert] = t('videos.too_many_videos')
    creation_error
  rescue Errors::InvalidVideoUrlError
    flash.now[:alert] = t('videos.invalid_video_url')
    creation_error
  rescue Errors::NoVideosGivenError
    flash.now[:alert] = t('videos.no_videos_given')
    creation_error
  rescue
    flash.now[:alert] = t('videos.an_error_occurred')
    creation_error
  end

  # POST /videos/1/transcription
  def transcription
    raise Errors::AuthorizationError unless uploadable?(@video)
    redirect_path = current_user.admin? ? @video : dashboard_path
    transcription = params.require(:video).require(:transcription_file)
    @video.save_transcription(transcription)
    redirect_to redirect_path, notice: t('videos.upload_succeeded')
  rescue => e
    redirect_to redirect_path, alert: t('videos.upload_failed')
  end

  # POST /videos/aPvbxuOBQ70/transcription
  def auto_transcription
    @video = Video.find_by!(yt_id: params[:id])
    auto_transcription = params.require(:auto_transcription_file)
    @video.save_auto_transcription(auto_transcription)
    render json: { success: true }
  rescue AuthenticationError
    render json: { success: false }, status: 401
  rescue => e
    render json: { success: false }, status: 400
  end

  def assign
    if assignable?(@video)
      current_user.videos << @video
      if current_user.save!
        redirect_to dashboard_path, notice: t('users.assigned_successfully')
      else
        redirect_to dashboard_path, alert: t('users.failed_to_assign')
      end
    else
      raise Errors::AuthorizationError
    end
  end

  def helpful_list
    @videos = Video.public_send params[:list_name]
    render :helpful_list
  end

  def need_transcription
    @videos = Video.need_transcription
  end

  def authorize!
    return if current_user.admin?
    raise Errors::AuthorizationError
  end

  private

  def creation_error
    @yt_urls = params[:yt_urls]
    render :new
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_video
    @video = Video.find(params[:id])
  end
end
