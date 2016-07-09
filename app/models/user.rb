class User < ActiveRecord::Base
    has_secure_password
    has_many :entries, dependent: :destroy
    validates :first_name, :last_name, presence: true
    validates :user_name, on: :create, length: { minimum: 8 }, uniqueness: true, presence: true
    validates :password, on: :create, length: { minimum: 8 }, presence: true
    validates :password, on: :update_pw, length: { minimum: 8 }, presence: true
    
    def update_password(update_user_params)
        
        old_password = update_user_params.delete(:old_password)
        
        if self.authenticate(old_password)
            # assign attributes without saving it to the database
            self.assign_attributes(update_user_params)
            
            # check if password and/or confirm password is presence. check it against the :update_pw context
            self.save(context: :update_pw)
        else
            self.errors.add(:old_password, 'is invalid')
            false
        end
    end
end
