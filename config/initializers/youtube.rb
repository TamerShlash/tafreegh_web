require 'google/apis/youtube_v3'

YT = Google::Apis::YoutubeV3
Youtube = YT::YouTubeService.new
Youtube.key = ENV.fetch('YOUTUBE_API_KEY', 'AIzaSyCANIpOUZd0-DKliNE_--9G_WyEdyLOiOg')
