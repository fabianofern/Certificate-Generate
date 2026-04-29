module Api
  module V1
    class CertificatesController < ApplicationController
      before_action :authorize_api_management!, except: [:index, :show]
      before_action :authorize_api_admin!, only: [:destroy]
      before_action :set_certificate, only: [:show, :destroy, :resend_email, :download]

      # GET /api/v1/certificates
      def index
        @certificates = Certificate.includes(:event, :participant).all.order(created_at: :desc)
        render json: @certificates.as_json(include: [:event, :participant])
      end

      # GET /api/v1/certificates/:id
      def show
        render json: @certificate.as_json(include: [:event, :participant, :email_logs])
      end

      # DELETE /api/v1/certificates/:id
      def destroy
        @certificate.destroy
        head :no_content
      end

      # POST /api/v1/certificates/:id/resend_email
      def resend_email
        # TODO: Implementar reenvio de email com Sidekiq
        render json: { message: 'Reenvio será implementado no próximo passo' }, status: :ok
      end

      # GET /api/v1/certificates/:id/download
      def download
        # TODO: Implementar download do PDF
        render json: { message: 'Download será implementado no próximo passo' }, status: :ok
      end

      private

      def set_certificate
        @certificate = Certificate.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Certificado não encontrado' }, status: :not_found
      end
    end
  end
end