class Message < ApplicationRecord
    searchkick word_middle: [:body]#[:chat_id]
    belongs_to :chat, optional: true
    validates :chat_id, presence: true
    #validate chat & message_number unique
    validates :chat_id, uniqueness: { scope: :message_number }
    validates :body, presence: true

    # def search_data
    #     {
    #       body: body,
    #       chat_id: chat_id
    #     }
    # end
end
