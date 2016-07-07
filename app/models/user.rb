class User < ActiveRecord::Base
    has_secure_password
    has_many :entries, dependent: :destroy
    validates :password, presence: { on: create }, length: { minimum: 8 }
    validates :user_name, presence: { on: create }, length: { minimum: 8 }
end
