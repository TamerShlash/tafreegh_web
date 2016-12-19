class YoutubeFetcher
  attr_accessor :video_ids

  SNIPPET_FIELDS = ['category_id', 'channel_id', 'channel_title', 'published_at', 'tags']

  def initialize(video_urls)
    raise Errors::TooManyVideosError if video_urls.lines.length > 10
    self.video_ids = video_urls.lines.map do |line|
      begin
        CGI.parse(URI.parse(line.strip).query)['v']
      rescue
        raise Errors::InvalidVideoUrlError
      end
    end.flatten.uniq.compact
    raise Errors::NoVideosGivenError if video_ids.blank?
    self.video_ids -= Video.where(yt_id: video_ids).pluck(:yt_id)
  end

  def fetch!
    return if video_ids.blank?
    remote_videos = Youtube.fetch_all do |token, service|
      service.list_videos('snippet', id: video_ids.join(','), page_token: token)
    end
    videos = remote_videos.map do |rv|
      Video.new(yt_id: rv.id, title: rv.snippet.title,
                description: rv.snippet.description,
                snippet: rv.snippet.as_json.slice(*SNIPPET_FIELDS).to_json)
    end
    Video.import! videos
  end
end
