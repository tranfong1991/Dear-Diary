class User < ActiveRecord::Base
    has_secure_password
    has_many :entries, dependent: :destroy
    validates :password, on: :create , length: { minimum: 8 }
    validates :password, length: { minimum: 8 }, on: :update, allow_blank: true
    validates :user_name, presence: { on: create }, length: { minimum: 8 }
    
    def update_password(update_user_params)
        old_password = update_user_params.delete(:old_password)
        
        if self.authenticate(old_password)
            self.update_attributes(update_user_params)
        else
            self.errors.add(:old_password, 'is invalid')
            false
        end
    end
end
