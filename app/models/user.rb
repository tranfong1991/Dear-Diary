class User < ActiveRecord::Base
    has_secure_password
    has_many :entries, dependent: :destroy
    validates :password, on: :create , length: { minimum: 8 }
    validates :password, length: { minimum: 8 }, on: :update, allow_blank: true
    validates :user_name, presence: { on: create }, length: { minimum: 8 }
end
