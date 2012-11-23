module GS
  class Flickr

    TTL = 3600

    ##
    # Get a list of flickr sets, from cache if possible.
    #
    def self.sets
      key = 'flickr.photoset.getList'
      sets = MC.get(key)
      if sets.nil?
        sets = flickr.photosets.getList(:user_id => AUTH['flickr']['id'])
      end
      MC.set(key, sets, TTL)
      sets
    end

    ##
    # Get a list of flickr collections, from cache if possible.
    #
    def self.collections
      key = 'flickr.collections.getTree'
      collections = MC.get(key)
      if collections.nil?
        collections = flickr.collections.getTree(:user_id => AUTH['flickr']['id'])
      end
      MC.set(key, collections, TTL)
      collections
    end

    ##
    # Get photo set info, from cache if possible.
    #
    def self.setInfo(id=nil)
      key = "flickr.photosets.getInfo.#{id}"
      set = MC.get(key)
      if set.nil?
        set = flickr.photosets.getInfo(:photoset_id=>id)
      end
      MC.set(key, set, TTL)
      set
    end

    ##
    # Get a photos in a set, from cache if possible.
    #
    def self.photosInSet(id=nil)
      # get most recent set if none is defined
      id = self.sets[0].id if id.nil?

      key = "flickr.photosets.getPhotos.#{id}"
      photos = MC.get(key)
      if photos.nil?
        photos = flickr.photosets.getPhotos(:photoset_id=>id)
      end
      MC.set(key, photos, TTL)
      photos.photo
    end

    ##
    # Get a recently uploaded photos, from cache if possible.
    #
    def self.recentPhotos
      key = "flickr.photos.getRecent"
      photos = MC.get(key)
      if photos.nil?
        photos = flickr.photos.search(:user_id => AUTH['flickr']['id']).map { |photo| photo.id }
      end
      MC.set(key, photos, TTL)
      photos
    end

    ##
    # Add cross-referencing links to photo description
    # indicating what journals an image has appeared in.
    #
    def self.setGSMeta(photo_id)
      # get photo info
      photo = flickr.photos.getInfo(:photo_id => photo_id)
      # get current description, less any automated data
      description = photo.description.split("\n---\n")[0]||""
      # get all journals where this photo appears
      journals = Journal.published.
                         exclude(Sequel.function(:strpos,:body,photo_id.to_s)=>0).
                         order(:stamp).
                         all
      # make line entry for every journal this photo is featured in.
      entries = []
      journals.each do |journal|
        entries.push("<a href=\"#{journal.href}\">#{journal.title}</a> (#{journal.date})")
      end

      # add automatic links if this photo appears in any journals
      if !entries.empty?
        description += "\n---\n\n<strong>Featured in the following journals:</strong>\n"
        description += entries.join("\n")
      end

      flickr.photos.setMeta(
        :photo_id => photo_id,
        :title => photo.title,
        :description => description
      )
    end

  end
end
