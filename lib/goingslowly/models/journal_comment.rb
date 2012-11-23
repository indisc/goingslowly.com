module GS
  class JournalComment < Sequel::Model
    many_to_one :journal

    include Helpers

    attr_accessor :recaptcha

    dataset_module do
      def published
        where(:published=>true)
      end
    end

    def body
      body = Sanitize.clean(@values[:body], :elements => %w[br a strong b i u em strike])
      body.gsub(/\n/, '<br />')
    end

    def email
      template = Tilt.new("lib/goingslowly/views/emails/comment.slim")
      template.render(nil, :item => self)
    end

    def timestamp
      stamp.strftime("%B #{ordinalize(stamp.strftime('%e'))}, %Y at %l:%M %p")
    end

    # return an array of emails for people who should receive a
    # notification about this comment
    def notify
      self.class.
      select(Sequel.lit('DISTINCT lower(email)').as(:email),:journal_id).
      where(:alerts=>true,:journal_id=>journal_id).
      exclude(:email=>nil).
      where{|o| o.id < @values[:id]}.
      all.map { |i| i[:email] }
    end

    def validate
      super
      validates_presence [:name, :email, :body], :allow_blank => false
      errors.add(:email,'invalid email') if !validEmail?(email)

      if !recaptchaCorrect?(recaptcha)
        errors.add(:recaptcha,'letters did not match')
      end
    end

  end
end
