module GS
  class Media
    ##
    # Use Tilt to render a photo model.
    #
    def self.renderPhoto(type, photo)
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

  end
end
