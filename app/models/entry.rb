class Entry < ActiveRecord::Base
    belongs_to :user
    validates :content, presence: true

    self.per_page = 3
end
