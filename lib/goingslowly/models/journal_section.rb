module GS
  class JournalSection < Sequel::Model
    one_to_many :journal_topic

    dataset_module do
      def topics
        eager_graph(:journal_topic => proc { |ds| ds.where(:is_country=>false)}).
        order([:ordering,:journal_topic__name])
      end
    end
  end
end
