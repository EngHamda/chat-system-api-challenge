class Api::V1::MessageWorker
    include Sidekiq::Worker
    sidekiq_options retry: false
    
    def perform(p_token, p_chat_number)
        puts "MESSAGE WORKER GENERATING A MESSAGE TO CHATE #{p_chat_number} IN APPLICATION HAS THIS TOKEN #{p_token} "
    end
    
end