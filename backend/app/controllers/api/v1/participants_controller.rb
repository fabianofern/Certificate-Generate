module Api
  module V1
    class ParticipantsController < ApplicationController
      before_action :authorize_api_management!, except: [:index, :show]
      before_action :authorize_api_admin!, only: [:destroy]
      before_action :set_participant, only: [:show, :update, :destroy]

      # GET /api/v1/participants
      def index
        @participants = Participant.all.order(name: :asc)
        render json: @participants
      end

      # GET /api/v1/participants/:id
      def show
        render json: @participant
      end

      # POST /api/v1/participants
      def create
        @participant = Participant.new(participant_params)

        if @participant.save
          render json: @participant, status: :created
        else
          render json: { errors: @participant.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/participants/:id
      def update
        if @participant.update(participant_params)
          render json: @participant
        else
          render json: { errors: @participant.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/participants/:id
      def destroy
        @participant.destroy
        head :no_content
      end

      # POST /api/v1/participants/import
      def import
        if params[:file].blank?
          return render json: { error: 'Nenhum arquivo enviado' }, status: :unprocessable_entity
        end

        # TODO: Implementar importação de planilha com roo ou creek
        render json: { message: 'Importação será implementada no próximo passo' }, status: :ok
      end

      private

      def set_participant
        @participant = Participant.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Participante não encontrado' }, status: :not_found
      end

      def participant_params
        params.require(:participant).permit(:name, :email, :cpf)
      end
    end
  end
end
