Sequel.migration do

  up do
    # Authors for journal entries
    create_table(:journal_author) do
      primary_key :id

      column :name, String
      column :email, String

      index :email, :unique=>true
      index :name, :unique=>true
    end

    # Share random bits of javascript between journal entries
    create_table(:journal_widget) do
      primary_key :id

      column :name, String, :text=>true, :null=>false
      column :code, String, :text=>true, :null=>false

      index :name, :unique=>true
    end

    # Rating levels for journal entries
    create_table(:journal_rating) do
      primary_key :id

      column :name, String, :text=>true, :null=>false
      column :display, String, :text=>true

      index :name, :unique=>true
    end

    # Overall sections for journal entries
    create_table(:journal_section) do
      primary_key :id

      column :name, String, :null=>false
      column :ordering, Integer

      index :name, :unique=>true
    end

    # Tagging for journal entries
    create_table(:journal_topic) do
      primary_key :id

      column :name, String, :null=>false
      column :title, String, :null=>false
      column :description, String, :text=>true, :null=>false
      column :is_country, TrueClass, :default=>false, :null=>false
      column :show, TrueClass, :default=>false, :null=>false

      foreign_key :journal_section_id, :journal_section

      index :name, :unique=>true
    end

    # Shared title prefixes for journal entries
    create_table(:journal_title) do
      primary_key :id

      column :name, String, :text=>true, :null=>false

      index :name, :unique=>true
    end

    # Journal entries
    create_table(:journal) do
      primary_key :id

      column :href, String, :text=>true
      column :title, String, :text=>true
      column :body, String, :text=>true
      column :stamp, DateTime, :default=>Sequel::CURRENT_TIMESTAMP, :null=>false
      column :published, TrueClass, :default=>false, :null=>false
      column :filed, TrueClass, :default=>false, :null=>false
      column :commissioned, TrueClass, :default=>false, :null=>false
      column :locked, TrueClass, :default=>false, :null=>false
      column :date_publish, Date
      column :js, String, :text=>true
      column :nocomments, TrueClass, :default=>false, :null=>false

      foreign_key :day_id, :day
      foreign_key :journal_author_id, :journal_author, :null=>false
      foreign_key :journal_rating_id, :journal_rating, :null=>false
      foreign_key :photo_id, :photo, :default => 1
      foreign_key :journal_title_id, :journal_title, :null=>false

      index [:published, :date_publish, :stamp]
      index [:published, :date_publish, "date(stamp)".lit]
      index [:published, :date_publish, "date_trunc('month',stamp)".lit]
      index [:published, :date_publish, "date_trunc('year',stamp)".lit]
      index [:published, :date_publish, "(date_part('month',stamp)::text||date_part('day',stamp))".lit]
      index [:published, :date_publish, :journal_rating_id]
    end

    # Assign topics to journals
    create_table(:journal_topics_journals) do
      foreign_key :journal_id, :journal, :null=>false
      foreign_key :journal_topic_id, :journal_topic, :null=>false

      index [:journal_topic_id]
      index [:journal_id, :journal_topic_id], :unique=>true
    end

    # Assign widgets to journals
    create_table(:journal_widgets_journals) do
      foreign_key :journal_id, :journal, :null=>false
      foreign_key :journal_widget_id, :journal_widget, :null=>false

      index :journal_widget_id
      index [:journal_id, :journal_widget_id], :unique=>true
    end

    # Assign locations for journal entries
    create_table(:journals_locations) do
      foreign_key :location_id, :location, :null=>false
      foreign_key :journal_id, :journal, :null=>false

      index [:location_id, :journal_id], :unique=>true
    end

    # Journal entry comments
    create_table(:journal_comment) do
      primary_key :id

      column :name, String, :text=>true, :null=>false
      column :email, String, :text=>true
      column :body, String, :text=>true, :null=>false
      column :stamp, DateTime, :default=>Sequel::CURRENT_TIMESTAMP, :null=>false
      column :url, String
      column :ip, :cidr
      column :published, TrueClass, :default=>true, :null=>false
      column :authorpost, TrueClass, :default=>false, :null=>false
      column :alerts, TrueClass, :default=>false, :null=>false
      column :captcha, String

      foreign_key :journal_id, :journal, :null=>false

      index [:journal_id, :published]
    end

  end

  down do
    drop_table(:journals_locations)
    drop_table(:journal_comment)
    drop_table(:journal_journal_widget)
    drop_table(:journal_journal_topic)
    drop_table(:journal)
    drop_table(:journal_title)
    drop_table(:journal_topic)
    drop_table(:journal_section)
    drop_table(:journal_rating)
    drop_table(:journal_widget)
    drop_table(:journal_author)
  end

end
