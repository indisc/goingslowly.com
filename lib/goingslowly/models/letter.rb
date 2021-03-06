module GS
  class Letter < Sequel::Model
    dataset_module do
      def published
        where(:published=>true).
        order(:date_sent.desc)
      end
    end

    def date
      date_sent.strftime("%A %B #{ordinalize(date_sent.strftime('%e'))}, %Y")
    end
  end
end
