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

    def src(size=:normal)
      case size
        when :normal
          "#{CONFIG['url']['photos']}/normal/#{f_id}.#{type}"
        when :large
          "#{f_url_base}_b.jpg"
        when :thumb
          "#{CONFIG['url']['photos']}/thumbnail/#{f_id}.#{type}"
        when :featured
          "#{CONFIG['url']['photos']}/thumbnail/#{f_id}.#{type}"
      end
    end

    def render(type)
      Media.renderPhoto(type, self)
    end
  end
end
