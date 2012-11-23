module GS
  class App < Sinatra::Base
    subdomain '' do

      ##
      # Woohoo, the home page!
      #
      get '/' do
        footer = footerContext()
        slim :index, :locals => {
          :news => News.published.limit(2).all,
          :photos => Photo.byFlickrId(Flickr.recentPhotos).
                           limit(32).all,
          :journals => footer[:journals],
          :footer => footer
        }
      end

      ##
      # Show gear listing.
      # TODO: expand to support a gear listing for homesteading?
      #
      get '/gear' do
        slim :gear
      end

      ##
      # Getting internet abroad.
      # TODO: move this to somewhere less prominent.
      #
      get '/internet' do
        slim :internet
      end

      ##
      # Crappy overview about how to plan for a bike tour.
      # TODO: move this to somewhere less prominent.
      #
      get '/planning' do
        slim :planning
      end

      ##
      # Landing page for paypal donations.
      #
      get '/donationthankyou' do
        slim :donationthankyou
      end

      ##
      # A search-able table of countries and the vaccinations recommended in them.
      #
      get '/vaccinations' do
        slim :vaccinations
      end

      ##
      # A listing of places we've written for or have been mentioned on the web.
      #
      get '/news' do
        slim :news, :locals => {
          :news => News.published.all
        }
      end

      ##
      # A viewable listing of all our photo sets on flickr, grouped by collection.
      #
      get '/photos/?:title?/?:set_id?' do
        params[:set_id] = Flickr.sets[0].id if params[:set_id].nil?
        slim :photos, {
          :layout => false,
          :locals => {
            :collections => Flickr.collections,
            :set => Flickr.setInfo(params[:set_id]),
            :photos => Flickr.photosInSet(params[:set_id])
          }
        }
      end

      ##
      # Cool letters we've received over the years.
      #
      get '/letters' do
        slim :letters, {
          :layout => false,
          :locals => {
            :letters => Letter.order_by(:date_sent.desc).all,
            :x => -15000,
            :y => -10000,
            :dir => "up",
            :last => "up"
          }
        }
      end

      ##
      # Our contact page.
      #
      get '/contact' do
        slim :contact
      end

      ##
      # Process contact form.
      #
      post '/contact' do
        email = Email.new(request)
        if email.valid?
          body = slim(:'emails/contact', { :locals => params[:contact], :layout=>false })
          sendEmail('tyler@sleekcode.net','Going Slowly Contact',body,params[:contact][:email])
          sendEmail('taraalan@gmail.com','Going Slowly Contact',body,params[:contact][:email])
          formSuccess
        else
          formError(email.errors)
        end
      end

      ##
      # Newsletter signup page.
      #
      get '/newsletter' do
        slim :newsletter, :layout => (params[:popup] ? false : :layout)
      end

      ##
      # Process newsletter signup form.
      # TODO: insert into email list database automatically.
      #
      post '/newsletter' do
        signup = Newsletter.new(request)
        if signup.valid?
          sendEmail('tyler@sleekcode.net','Newsletter Signup',params.inspect)
          formSuccess("Thanks for signing up!")
        else
          formError(signup.errors)
        end
      end

      ##
      # A sample photo loader, shown on:
      # http://journal.goingslowly.com/2011/01/our-process-automation-journal-photos
      #
      get '/photoloader' do
        slim :photoloader, {
          :layout => false,
          :locals => {
            :sets => Flickr.sets
          }
        }
      end

      ##
      # Process photo loader requests.
      #
      post '/photoloader' do
        output = []
        if params[:photoset_id].nil?
          output.push('No set defined.')
        end
        photos = Flickr.photosInSet(params[:photoset_id])
        photos.each do |photo|
          url = "http://farm#{photo.farm}.static.flickr.com/#{photo.server}/#{photo.id}_#{photo.secret}_z.jpg"
          title = "#{photo.title}"
          output.push("<p><img src=\"#{url}\" title=\"#{title}\"/></p>")
        end
        output.join("\n")
      end


      ##
      # Synopsis pages for various adventures in our lives.
      ##

      get '/bicycle-touring-in-western-europe' do
        slim :btiwe, {
          :layout => :layout_adventure,
          :locals => {
            :img => 'btiwe',
            :centeredY => false
          }
        }
      end

      get '/tunisia-on-two-wheels' do
        slim :totw, {
          :layout => :layout_adventure,
          :locals => {
            :img => 'totw',
            :centeredY => false
          }
        }
      end

      get '/bicycle-touring-in-eastern-europe' do
        slim :btiee, {
          :layout => :layout_adventure,
          :locals => {
            :img => 'btiee',
            :centeredY => true
          }
        }
      end

      get '/eastern-european-road-trip' do
        slim :eert, {
          :layout => :layout_adventure,
          :locals => {
            :img => 'eert',
            :centeredY => false
          }
        }
      end

      get '/scandinavian-road-trip' do
        slim :srt, {
          :layout => :layout_adventure,
          :locals => {
            :img => 'srt',
            :centeredY => false
          }
        }
      end

      get '/russian-road-trip' do
        slim :rrt, {
          :layout => :layout_adventure,
          :locals => {
            :img => 'rrt',
            :centeredY => false
          }
        }
      end

      get '/mongolian-road-trip' do
        slim :mrt, {
          :layout => :layout_adventure,
          :locals => {
            :img => 'mrt',
            :centeredY => false
          }
        }
      end

      get '/bicycle-touring-in-southeast-asia' do
        slim :btisa, {
          :layout => :layout_adventure,
          :locals => {
            :img => 'btisa',
            :centeredY => false
          }
        }
      end

      get '/coming-home-return-to-america' do
        slim :chrta, {
          :layout => :layout_adventure,
          :locals => {
            :img => 'chrta',
            :centeredY => false
          }
        }
      end

      get '/land-hunting-finding-our-homestead' do
        slim :lhfoh, {
          :layout => :layout_adventure,
          :locals => {
            :img => 'lhfoh',
            :centeredY => false
          }
        }
      end

      #get '/budget' do
      #  daysleft = days_in_month(Date.today.year, Date.today.month)-Date.today.day
      #  owed = 55000
      #  paid = 55000
      #  budget = 600.00
      #  spent = DB[:budget].where(:id=>1).get(:total)
      #  daily = ((budget-spent)/daysleft).round(2)
      #  slim :budget, :locals => {
      #    :owed => owed,
      #    :paid => paid,
      #    :budget => budget,
      #    :spent => spent,
      #    :daily => daily
      #  }
      #end
    end
  end
end
