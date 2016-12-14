module VideosHelper
  def batch_textare_placeholder
    sample = %w(ePxKbPPj97Y Q3EblPrqk7g BoLt1VZ7sXE CrqhR9fbmLQ Y_7HFXmAptk
                Yv5ovdvvWoM cF2e2aS9HN8).each_with_object('') do |id, str|
      str << "https://www.youtube.com/watch?v=#{id}\r\n"
    end

    sample.prepend("مثال:\n")
  end

  def helpful_list_links
    {
      t('videos.lists.all') => videos_path,
      t('videos.lists.transcribed') => transcribed_videos_path,
      t('videos.lists.not_transcribed') => not_transcribed_videos_path,
      t('videos.lists.auto_transcribed') => auto_transcribed_videos_path,
      t('videos.lists.not_auto_transcribed') => not_auto_transcribed_videos_path,
      t('videos.lists.transcribed_both') => transcribed_both_videos_path,
      t('videos.lists.transcribed_neither') => transcribed_neither_videos_path
    }
  end
end
