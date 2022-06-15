class Api::V1::ChatWorker
    include Sidekiq::Worker
    sidekiq_options retry: false
    
    def perform(p_token)
        puts "CHAT WORKER GENERATING A CHAT TO APPLICATION HAS THIS TOKEN #{p_token} "
    end
    
end