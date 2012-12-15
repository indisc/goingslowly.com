require 'RMagick'

module GS
  class Media

    ##
    # Use Tilt to render a photo model.
    #
    def self.renderPhoto(type, photo)
      if photo.nil?
        photo = Photo[:id=>1]
      end
      template = Tilt.new("lib/goingslowly/views/_photo_#{type}.slim")
      template.render(nil, :item => photo)
    end

    ##
    # Use Tilt to render a video object.
    #
    def self.renderVideo(type, video)
      template = Tilt.new("lib/goingslowly/views/_video_#{type}.slim")
      template.render(nil, :item => video)
    end

    ##
    # Resize a photo blob and return a blob.
    #
    def self.resizePhoto(blob, width, type)
      tmp = "tmp/tmp.#{type}"
      Magick::Image.from_blob(blob).first.resize_to_fit(width).sharpen(0,0.5).write(tmp) {
        self.interlace = Magick::PlaneInterlace
        self.quality = 85
      }

      # Force garbage collection so ruby doesn't blow up.
      GC.start
      # Nice work, ruby.

      case type
        when 'jpg'
          `jpegoptim --preserve --strip-com --strip-exif --strip-iptc #{tmp}`
        when /png$/i
          `optipng #{tmp}`
      end
      File.read(tmp)
    end

  end
end
