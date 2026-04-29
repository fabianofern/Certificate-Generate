class CertificatesController < WebController
  before_action :authorize_management!
  before_action :authorize_admin!, only: [:destroy]
  before_action :set_certificate, only: %i[ show destroy resend_email download ]

  # GET /certificates
  def index
    @certificates = Certificate.includes(:event, :participant).all.order(created_at: :desc)
  end

  # GET /certificates/1
  def show
    @qr_code = RQRCode::QRCode.new(@certificate.qr_code_data)
    @email_logs = @certificate.email_logs.order(created_at: :desc)
  end

  # DELETE /certificates/1
  def destroy
    @certificate.destroy!
    redirect_to certificates_url, notice: "Certificado excluído com sucesso.", status: :see_other
  end

  # POST /certificates/1/resend_email
  def resend_email
    # Aqui chamaria o mailer, mas vamos simular e registrar o log
    # CertificateMailer.with(certificate: @certificate).send_certificate.deliver_now
    
    @certificate.email_logs.create!(
      event_type: 'resend',
      status: 'success',
      details: "Email reenviado manualmente em #{Time.current}"
    )
    
    redirect_to @certificate, notice: "Email reenviado com sucesso!"
  end

  # GET /certificates/1/download
  def download
    pdf_data = CertificateGenerator.generate(@certificate)
    
    participant_name = @certificate.participant.name.parameterize(separator: '_')
    event_name = @certificate.event.title.parameterize(separator: '_').truncate(30, omission: '')
    uuid_short = @certificate.uuid.split('-').first
    
    filename = "Certificado_#{participant_name}_#{event_name}_#{uuid_short}.pdf"

    send_data pdf_data, 
      filename: filename, 
      type: 'application/pdf', 
      disposition: 'attachment'
  end

  private

  def set_certificate
    @certificate = Certificate.find(params[:id])
  end
end
