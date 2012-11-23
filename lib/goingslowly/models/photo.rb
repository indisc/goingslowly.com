module GS
  class Photo < Sequel::Model
    dataset_module do
      def byFlickrId(id)
        where(:f_id=>id)
      end
    end

    def link
      "#{CONFIG['url']['flickr']}/#{f_id}"
    end

    def src(type=:standard)
      case type
        when :standard
          "#{CONFIG['url']['photos']}/#{s_id}-783x522.jpg"
        when :large
          "#{f_url_base}_b.jpg"
        when :thumb
          "#{CONFIG['url']['photos']}/#{s_id}-96x160.jpg"
        when :featured
          "#{CONFIG['url']['photos']}/#{s_id}-172x115.jpg"
      end
    end

    def render(type)
      Media.renderPhoto(type, self)
    end
  end
end
