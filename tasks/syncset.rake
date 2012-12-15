task :syncset do
  require 'open-uri'
  require './lib/goingslowly'
  require './lib/goingslowly/classes/s3'
  include GS

  # open connection to s3
  S3 = S3.new

  # destination bucket
  bucket = 's3.goingslowly.com'

  # photos in defined set
  photos = flickr.photosets.getPhotos(:photoset_id=>ENV['id']).photo

  # iterate photos and save them to s3
  photos.each do |photo|

    # get photo data
    photo = flickr.photos.getInfo(:photo_id=>img.f_id)
    url = FlickRaw.url_o(photo)
    type = photo.originalformat
    name = "#{photo.id}.#{type}"

    # read photo from flickr
    puts "Reading #{url}..."
    blob = open(url).read

    # store thumbnail
    S3.save({
      :name => "photos/thumbnail/#{file}",
      :blob => GS::Media.resizePhoto(blob, 192, type),
      :bucket => bucket,
      :access => :public_read
    })

    # store normal size
    S3.save({
      :name => "photos/normal/#{file}",
      :blob =>  GS::Media.resizePhoto(blob, 783, type),
      :bucket => bucket,
      :access => :public_read
    })
  end
end
