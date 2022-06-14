class Api::V1::ChatsController < ApplicationController
    before_action :find_chat_by_chat_number_and_app_token, only: [:show, :search]
    before_action :find_application_by_app_token, only: [:create]

    # GET /applications/:token/chats/:number
    def show
        if @chat_application
            render json: @chat_application.to_json(except: [:id, :application_id, :messages_count]), status: 200#TODO: add message attribute
        else
            render json: {error: 'Unable to get Chat.'}, status: 400
        end
    end

    # POST /applications/:token/chats
    def create
        @chat = @application.chats.new(chat_params)
        @application.chats_count +=1
        #Note: when save parent automatic child saved
        if @application.save
            render json:set_true_response('Chat successfully created.'), status: 200
        else
            render json: {error: 'Unable to create Chat.'}, status: 400
        end
    end


    # GET /applications/:token/chats/:chat_number/search
    def search
        if !params[:substring] 
            render json: {error: 'Invalid substring parameter.'}, status: 400
        elsif !@chat_application
            render json: {error: 'Unable to get Chat.'}, status: 400
        else
            #from app_token & chat_number get chat_ids
            substring = params[:substring]
            chat_id = @chat_application.id
            #TODO: use chat_id in elasticsearch query
            search_result = Message.where("body LIKE ? ", "%#{substring}%")
            if search_result.empty?
                render json: {msg: 'No message in this Chat.'}, status: 200
            end
            response = [];
            search_result.each do |result_item|
                if chat_id == result_item.chat_id
                    response << {
                        :message_number => result_item.message_number, :body => result_item.body,
                        :created_at => result_item.created_at, :updated_at => result_item.updated_at
                    }
                end
            end
            render json: response, status: 200
        end
    end

    private
    def find_chat_by_chat_number_and_app_token
        #get chat from applications by token, chats by chat_number
        @chat_application = Api::V1::SharedMethod.find_chat_application(params[:number], params[:application_token])
    end

    def find_application_by_app_token
        #get application by token
        @application = Api::V1::SharedMethod.find_application(params[:application_token])
        if !@application
            render json: {error: 'Unable to get Application.'}, status: 400
        end
    end    

    def chat_params
        params = ActionController::Parameters.new(chat: { application_id: @application.id, chat_number: @application.chats_count+1 })
        params.require(:chat).permit(:application_id, :chat_number)
    end

    def set_true_response(pMsg)
        {
            message: pMsg,
            Application_Name: @application.name,
            Chat_Number: @chat.chat_number
        }
    end
end
