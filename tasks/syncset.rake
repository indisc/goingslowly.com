task :syncset do
  require './lib/goingslowly'
  require 'aws/s3'
  require 'open-uri'
  require 'RMagick'
  require 'jpegoptim'
  require 'optipng'

  # photo bucket
  bucket = 'photos.goingslowly.com'

  # photos in defined set
  photos = flickr.photosets.getPhotos(:photoset_id=>ENV['id']).photo

  # save an image to s3 after compressing it
  def store(type, name, blob, bucket, access)
    puts "Storing #{type}/#{name}..."
    s3file = AWS::S3::S3Object.store("#{type}/#{name}", blob, bucket, {
      :cache_control => 'max-age=315360000, public',
      :expires => (Time.now + 315360000).httpdate,
      :access => access
    })
  end

  # optimize / compress image with jpegoptim or optipng
  def optimize(blob, type)
    case type
      when 'jpg'
        tmp = 'tmp/tmp.jpg'
        File.open(tmp,'w+') { |f| f.write(blob) }
        Jpegoptim.optimize([tmp], { :preserve => true, :strip => :all })
        File.read(tmp)
      when /png$/i
        tmp = 'tmp/tmp.png'
        File.open(tmp,'w+') { |f| f.write(blob) }
        Optipng([tmp])
        File.read(tmp)
    end
  end

  # resize a photo and return a blob
  def resize(blob, width, type)
    Magick::Image.from_blob(blob).first.resize_to_fit(width).to_blob {
      self.interlace = Magick::PlaneInterlace
      self.quality = 80
    }
  end

  # iterate photos and save them to s3
  photos.each do |photo|
    photo = flickr.photos.getInfo(:photo_id=>photo.id)
    type = photo.originalformat
    file = "#{photo.id}.#{type}"

    # read photo from flickr
    blob = open(FlickRaw.url_o(photo)).read

    # store thumbnail, normal and doubled (for retina display eventually) sizes
    store(:thumbnail, file, optimize(resize(blob, 192, type), type), bucket, :public_read)
    store(:normal, file, optimize(resize(blob, 785, type), type), bucket, :public_read)
    store(:doubled, file, optimize(resize(blob, 1570, type), type), bucket, :public_read)
    #store(:original, file, optimize(blob, type), bucket, :private)
  end
end
