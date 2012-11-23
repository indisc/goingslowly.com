module GS
  class JournalWidget < Sequel::Model
    many_to_many :journal
  end
end
