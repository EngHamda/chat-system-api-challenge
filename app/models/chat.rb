class Chat < ApplicationRecord
    belongs_to :application, optional: true
    has_many :messages
    accepts_nested_attributes_for :messages
    validates :application_id, presence: true
    #validate application & chat_number unique
    validates :application_id, uniqueness: { scope: :chat_number }
end
