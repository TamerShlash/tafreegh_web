S3_BUCKET = Aws::S3::Bucket.new(
  ENV.fetch('S3_BUCKET_NAME'),
  access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  region: ENV.fetch('AWS_REGION')
)
