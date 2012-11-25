$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

# Load dependencies
require 'sinatra/base'
require 'sinatra/contrib'
require 'sinatra/subdomain'
require 'pg'
require 'sequel'
require 'slim'
require 'dalli'
require 'kgio'
require 'sanitize'
require 'flickraw-cached'
require 'riddle'

# Load configs
CONFIG = YAML::load(File.open('config/goingslowly.yml'))
AUTH = YAML::load(File.open('config/auth.yml'))

# Connect to databases
DB = Sequel.connect(CONFIG['db'])
MC = Dalli::Client.new('localhost:11211')
SPHINX = Riddle::Client.new(CONFIG['sphinx']['host'],CONFIG['sphinx']['port'])
SPHINX.match_mode = CONFIG['sphinx']['match_mode'].to_sym
SPHINX.limit = CONFIG['sphinx']['limit']

# Spool up flickr integration.
FlickRaw.api_key = AUTH['flickr']['api_key']
FlickRaw.shared_secret = AUTH['flickr']['shared_secret']
flickr.access_token = AUTH['flickr']['access_token']
flickr.access_secret = AUTH['flickr']['access_secret']

##
# Sequel::Model customization ({http://sequel.rubyforge.org/ Sequel})
#
class Sequel::Model
  plugin :validation_helpers
  Sequel::Plugins::ValidationHelpers::DEFAULT_OPTIONS.merge!(
    :presence=>{:message=>'cannot be empty'}
  )
  ##
  # Determine associated table of model by inflecting class name.
  #
  # @return [Symbol]
  #   The name of the table, de-camelcased with underscores.
  #   Account = account
  #   TransItem = trans_item
  #
  def self.implicit_table_name
    underscore(demodulize(name)).to_sym
  end
  def self.pluralize(word)
    word
  end
  def self.singularize(word)
    word
  end
end

# Load helpers.
require 'goingslowly/helpers/utils'
require 'goingslowly/helpers/assets'
require 'goingslowly/helpers/forms'
require 'goingslowly/helpers/email'
require 'goingslowly/helpers/core_ext'
require 'goingslowly/helpers/context'

# Load classes.
require 'goingslowly/classes/flickr'
require 'goingslowly/classes/parser'
require 'goingslowly/classes/media'
require 'goingslowly/classes/search'
require 'goingslowly/classes/cache'

# Load models.
require 'goingslowly/models/news'
require 'goingslowly/models/photo'
require 'goingslowly/models/member'
require 'goingslowly/models/journal_title'
require 'goingslowly/models/journal_section'
require 'goingslowly/models/journal_topic'
require 'goingslowly/models/journal_author'
require 'goingslowly/models/journal_rating'
require 'goingslowly/models/journal_widget'
require 'goingslowly/models/journal'
require 'goingslowly/models/journal_comment'
require 'goingslowly/models/letter'
require 'goingslowly/models/location'
require 'goingslowly/models/track'
require 'goingslowly/models/track_point'
require 'goingslowly/models/newsletter'
require 'goingslowly/models/email'
require 'goingslowly/models/fourohfour'

# Load sinatra.
require 'goingslowly/app'

# Load controllers.
require 'goingslowly/controllers/www'
require 'goingslowly/controllers/journal'
require 'goingslowly/controllers/map'
require 'goingslowly/controllers/admin'
