class Api::V1::MessagesController < ApplicationController
    before_action :find_application_by_app_token_and_chat_number_and_message_number, only: [:show]
    # before_action :find_application_by_app_token_and_chat_number_and_message_number, only: [:show, :create]
    # before_action :find_chat_by_chat_number_and_app_token, only: [:create, :update, :count]
    before_action :find_chat_by_chat_number_and_app_token, only: [:create, :update]
    # before_action :find_application, only: [:show, :update]

    # GET /applications/:token/chats/:number/messages/:number
    def show
        if @application_chat_message
            render json: @application_chat_message.to_json(except: [:id, :messages_count]), status: 200
        else
            render json: {error: 'Unable to get Message.'}, status: 400
        end
    end

    # POST /applications/:token/chats/:number/messages
    def create
        @message = @chat_application.messages.new(message_params_creation)
        @chat_application.messages_count +=1
        #Note: when save parent automatic child saved
        if @chat_application.save
                    # render json: message_params.to_json(except: :id), status: 200
            render json:set_true_response('Message successfully created.'), status: 200
        else
            render json: {error: 'Unable to create Message.'}, status: 400
        end
    end

    # PUT /applications/:token/chats/:number/messages/:number
    def update
        @message = @chat_application.messages.find_by(message_number: params[:number])
        if @message
            @message.update(message_params_update)
            render json:set_true_response('Message successfully updated.'), status: 200
        else
            render json:{error: 'Unable to update Message.'}, status: 400
        end
    end

    # # GET /applications/:token/chats/:number/count
    # def count
    #     @app_chat_messages = @chat_application.messages#.find_by(message_number: params[:number])
    #     render json: @app_chat_messages , status: 200
    # end

    private

    def find_application_by_app_token_and_chat_number_and_message_number
        #get message from applications by token, chats by chat_number, messages by message_number
        @application_chat_message = Application.joins(chats: :messages)
        .where(messages: { message_number: params[:number]  })
        .where(chats: { chat_number: params[:chat_number]  })
        .where(applications: { token: params[:application_token]  })
        .select(
            "applications.name AS application_name", "chats.chat_number", "chats.messages_count", 
            "messages.message_number", "messages.body", "messages.created_at", "messages.updated_at"
        )
        .first
    end

    def find_chat_by_chat_number_and_app_token
        #ask: what MessaeWorker functionality to queuing creation request?
        Api::V1::MessageWorker.perform_async(params[:application_token], params[:chat_number])
        #get chat from applications by token, chats by chat_number
        @chat_application = Api::V1::SharedMethod.find_chat_application(params[:chat_number], params[:application_token])
        if !@chat_application
            render json: {error: 'Unable to get Chat.'}, status: 400
        end
    end

    def message_params_creation
        msg_body = params[:message][:body]
        params = ActionController::Parameters.new(
            message: {message_number: @chat_application.messages_count+1, body: msg_body} 
        )
        params.require(:message).permit(:message_number, :body)
    end

    def message_params_update
        params.require(:message).permit(:body)
    end

    def set_true_response(pMsg)
        {
            message: pMsg,
            Application_Name: @chat_application.application.name,
            Chat_Number: @chat_application.chat_number,
            Message_Number: @message.message_number,
            Message_Body: @message.body
        }
    end
end
