module GS
  class Member < Sequel::Model
    def validate
      super
      validates_presence [:name, :email]
      if !validEmail?(email)
        errors.add(:email,'invalid email')
      end
    end
  end
end
