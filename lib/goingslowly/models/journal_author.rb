module GS
  class JournalAuthor < Sequel::Model
    one_to_many :journal
  end
end
