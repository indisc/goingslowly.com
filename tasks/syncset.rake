task :syncset do
  require 'aws/s3'
  require 'open-uri'
  require 'rmagick'
  require './lib/goingslowly'

  # connect to s3
  AWS::S3::Base.establish_connection!(
    :access_key_id     => AUTH['aws']['access_key_id'],
    :secret_access_key => AUTH['aws']['secret_access_key']
  )

  # photo bucket
  bucket = 'photos.goingslowly.com'

  # photos in defined set
  photos = GS::Flickr.photosInSet(ENV['id'])

  # save a photo to s3
  def store(type, name, blob, bucket, access)
    puts "Storing #{type}/#{name}..."
    s3file = AWS::S3::S3Object.store("#{type}/#{name}", blob, bucket, {
      :cache_control => 'max-age=315360000, public',
      :expires => (Time.now + 315360000).httpdate,
      :access => access
    })
  end

  # resize a photo and return a blob
  def resize(blob, width)
    Magick::Image.from_blob(blob).first.resize_to_fit(width).to_blob {
      self.interlace = Magick::PlaneInterlace
      self.quality = 80
    }
  end

  # iterate photos and save them to s3
  photos.each do |photo|
    photo = flickr.photos.getInfo(:photo_id=>photo.id)
    file = "#{photo.id}.#{photo.originalformat}"

    if !AWS::S3::S3Object.exists? "original/#{file}", bucket
      data = open(FlickRaw.url_o(photo)).read
      store(:thumbnail, file, resize(data, 96), bucket, :public_read)
      store(:normal, file, resize(data, 785), bucket, :public_read)
      store(:doubled, file, resize(data, 1570), bucket, :public_read)
      store(:original, file, data, bucket, :private)
    end

  end
end
