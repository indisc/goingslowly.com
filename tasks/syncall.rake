task :syncall do
  require './lib/goingslowly'
  require 'aws/s3'
  require 'open-uri'
  require 'RMagick'
  require 'jpegoptim'
  require 'optipng'
  require 'digest/sha1'

  # connect to s3
  AWS::S3::Base.establish_connection!(
   :access_key_id => AUTH['aws']['access_key_id'],
   :secret_access_key => AUTH['aws']['secret_access_key']
  )

  # photo bucket
  bucket = 's3.goingslowly.com'

  # save an image to s3 after compressing it
  def store(type, name, blob, bucket, access)
    puts "Storing #{type}/#{name}..."
    AWS::S3::S3Object.store("photos/#{type}/#{name}", blob, bucket, {
      :cache_control => 'max-age=315360000, public',
      :expires => (Time.now + 315360000).httpdate,
      :access => access
    })
  end

  # resize a photo and return a blob
  def resize(blob, width, type)
    tmp = "tmp/tmp.#{type}"
    Magick::Image.from_blob(blob).first.resize_to_fit(width).sharpen(0,0.5).write(tmp) {
      self.interlace = Magick::PlaneInterlace
      self.quality = 85
    }
    case type
      when 'jpg'
        `jpegoptim --preserve --strip-com --strip-exif --strip-iptc tmp/tmp.jpg`
      when /png$/i
        Optipng([tmp])
    end
    File.read(tmp)
  end

  # iterate photos and save them to s3
  while DB[:photo].where(:uploaded=>false).count != 0
    f_id = DB[:photo].where(:uploaded=>false,:uploading=>false).order(:id).limit(1).get(:f_id)
    DB[:photo].where(:f_id=>f_id).update(:uploading=>true)

    photo = flickr.photos.getInfo(:photo_id=>f_id)
    type = photo.originalformat
    file = "#{photo.id}.#{type}"

    # read photo from flickr
    blob = open(FlickRaw.url_o(photo)).read

    # store thumbnail, normal and doubled (for retina display eventually) sizes
    store(:thumbnail, file, resize(blob, 192, type), bucket, :public_read)
    store(:normal, file, resize(blob, 783, type), bucket, :public_read)
    #store(:doubled, file, resize(blob, 1566, type), bucket, :public_read)

    DB[:photo].where(:f_id=>f_id).update(:uploaded=>true,:uploading=>false)
  end
end
