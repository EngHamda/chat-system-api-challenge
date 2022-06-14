class Api::V1::ApplicationsController < ApplicationController
    before_action :find_application, only: [:show, :update]

    # GET /applications/:token
    def show
        # render json: params
        if @application
            render json: @application.to_json(except: [:id, :chats_count]), status: 200#TODO: add chates attribute
        else
            render json: {error: 'Unable to get Application.'}, status: 400
        end
    end

    # POST /applications
    def create
        @application = Application.new(application_params)
        if @application.save
            render json:set_true_response('Application successfully created.'), status: 200
            # render json: {
            #     message: 'Application successfully created.',
            #     Application_Name: @application.name,
            #     Application_Token: @application.token
            #     }, status: 200
        else
            render json: {error: 'Unable to create Application.'}, status: 400
        end
    end

    # PUT /applications/:token
    def update
        if @application
            @application.update(application_params)
            render json:set_true_response('Application successfully updated.'), status: 200
        else
            render json:{error: 'Unable to update Application.'}, status: 400
        end
    end

    private
    def application_params
        params.require(:application).permit(:name, :token)
        # params.require(:application).permit(:name, :token, chats_attributes: [:chat_number, :created_at, :updated_at ])
    end

    def find_application
        @application = Api::V1::SharedMethod.find_application(params[:token])
    end

    def set_true_response(pMsg)
        {
            message: pMsg,
            Application_Name: @application.name,
            Application_Token: @application.token
        }
    end
end
