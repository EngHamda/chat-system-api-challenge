class Application < ApplicationRecord
    has_many :chats
    accepts_nested_attributes_for :chats, :allow_destroy => true
    #to allow delete chats
        # accepts_nested_attributes_for :chats, :allow_destroy => true
    validates :name, presence: true
    has_secure_token :token
    validates_uniqueness_of :token
    validates :chats_count, presence: false
end
