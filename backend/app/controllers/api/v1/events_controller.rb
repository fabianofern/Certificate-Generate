module Api
  module V1
    class EventsController < ApplicationController
      before_action :authorize_api_management!, except: [:index, :show]
      before_action :authorize_api_admin!, only: [:destroy]
      before_action :set_event, only: [:show, :update, :destroy, :generate_certificates, :certificates]

      # GET /api/v1/events
      def index
        @events = Event.all.order(created_at: :desc)
        render json: @events
      end

      # GET /api/v1/events/:id
      def show
        render json: @event
      end

      # POST /api/v1/events
      def create
        @event = Event.new(event_params)

        if @event.save
          render json: @event, status: :created
        else
          render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/events/:id
      def update
        if @event.update(event_params)
          render json: @event
        else
          render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/events/:id
      def destroy
        @event.destroy
        head :no_content
      end

      # POST /api/v1/events/:id/generate_certificates
      def generate_certificates
        participant_ids = params[:participant_ids]

        if participant_ids.blank?
          return render json: { error: 'Nenhum participante selecionado' }, status: :unprocessable_entity
        end

        certificates = []
        participant_ids.each do |participant_id|
          participant = Participant.find_by(id: participant_id)
          next unless participant

          certificate = @event.certificates.find_or_initialize_by(participant: participant)
          certificate.save! if certificate.new_record?
          certificates << certificate
        end

        render json: {
          message: "#{certificates.count} certificado(s) gerado(s) com sucesso",
          certificates: certificates
        }, status: :created
      rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      # GET /api/v1/events/:id/certificates
      def certificates
        @certificates = @event.certificates.includes(:participant)
        render json: @certificates.as_json(include: :participant)
      end

      private

      def set_event
        @event = Event.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Evento não encontrado' }, status: :not_found
      end

      def event_params
        params.require(:event).permit(
          :title,
          :workload,
          :period,
          :location,
          :instructor_name,
          :instructor_email,
          :template_name
        )
      end
    end
  end
end