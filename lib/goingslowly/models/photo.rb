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

    def cdn
      "http://img#{(id%5)}.goingslowly.com/photos";
    end

    def src(size=:normal)
      case size
        when :normal
          "#{cdn}/normal/#{f_id}.#{type}"
        when :thumb
          "#{cdn}/thumbnail/#{f_id}.#{type}"
        when :featured
          "#{cdn}/thumbnail/#{f_id}.#{type}"
        when :large
          "#{f_url_base}_b.jpg"
      end
    end

    def render(type)
      Media.renderPhoto(type, self)
    end
  end
end
