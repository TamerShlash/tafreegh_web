class Video < ApplicationRecord
  scope :slim, lambda {
    select(
      :id,
      :yt_id,
      :title,
      :auto_transcribed,
      :transcribed,
      :auto_transcription,
      :transcription,
      :updated_at
    ).all
  }

  def save_auto_transcription(uploaded_file)
    s3_file = save_to_s3(uploaded_file, auto: true)
    update!(auto_transcribed: true, auto_transcription: s3_file.public_url)
  end

  def save_transcription(uploaded_file)
    s3_file = save_to_s3(uploaded_file, auto: false)
    update!(transcribed: true, transcription: s3_file.public_url)
  end

  private

  def save_to_s3(uploaded_file, auto: false)
    S3_BUCKET.put_object(
      acl: 'public-read',
      key: s3_object_key(uploaded_file, auto: auto),
      body: uploaded_file,
      content_language: 'ar',
      content_type: uploaded_file.content_type,
      content_disposition: 'attachment'
    )
  end

  def s3_object_key(uploaded_file, auto: false)
    extension = uploaded_file_extension(uploaded_file, auto: auto)
    "#{auto ? 'auto_transcription' : 'transcription'}/#{friendly_title}#{extension}"
  end

  def uploaded_file_extension(uploaded_file, auto: false)
    name_slices = uploaded_file.original_filename.split('.')
    if name_slices.length > 1
      ".#{name_slices.last}"
    elsif auto
      '.txt'
    else
      ''
    end
  end

  def friendly_title
    title.gsub(/[^\p{Word}\s_-]+/, '')
         .gsub(/(^|\b\s)\s+($|\s?\b)/, '\\1\\2')
         .gsub(/\s+/, '_')
         .strip
         .concat("_#{yt_id}")
  end
end
