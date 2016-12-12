class VideosController < ApplicationController
  before_action :set_video, only: [:show, :update]
  protect_from_forgery except: [:auto_transcription]
  before_action :verify_worker, only: :auto_transcription

  # GET /videos
  def index
    @videos = Video.slim.all
  end

  # GET /videos/1
  def show
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

  # PATCH/PUT /videos/1
  def update
    if @video.update(video_params)
      redirect_to @video, notice: 'Video was successfully updated.'
    else
      render :edit
    end
  end

  def auto_transcription
    @video = Video.find_by!(yt_id: params[:id])
    auto_transcription = params.require(:auto_transcription_file)
    @video.save_auto_transcription(auto_transcription)
    render json: { success: true }
  rescue => e
    puts e
    render json: { success: false }, status: 400
  end

  private

  def verify_worker
    return if request.headers['Tafreegh-Token'] == ENV.fetch('TAFREEGH_TOKEN')
    raise InvalidTafreeghTokenError
  end

  def creation_error
    @yt_urls = params[:yt_urls]
    render :new
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_video
    @video = Video.find(params[:id])
  end
end
