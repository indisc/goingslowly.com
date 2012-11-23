module GS
  class JournalTitle < Sequel::Model
    one_to_many :journal
    many_to_one :journal_section
  end
end
