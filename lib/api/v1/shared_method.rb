# lib/api/v1/shared_method.rb
=begin
-> Note: 
    As domain objects in lib. we must add it to autoload_paths:
        # config/application.rb
      config.autoload_paths << Rails.root.join('lib')  
=end
module Api::V1
  class SharedMethod
    def self.find_application(p_token)
      @application = Application.select(
          :id, :name, :token, :chats_count, :created_at, :updated_at
      ).find_by(token: p_token)
      # ).where(token: p_token).take
    end

    def self.find_chat_application(p_number, p_token)
      @chat_application = Chat.joins(:application)
      .where(applications: { token: p_token  })
      .where(chats: { chat_number: p_number  })
      .select("applications.name AS application_name", "chats.*")
      .first
    end
  end
end