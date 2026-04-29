class PublicCertificatesController < WebController
  layout 'public'

  def show
    @certificate = Certificate.find_by!(download_token: params[:token])
    
    if !@certificate.download_token_valid?
      render 'expired', status: :gone
    end
  end

  def download
    @certificate = Certificate.find_by!(download_token: params[:token])
    
    if @certificate.download_token_valid?
      pdf_data = CertificateGenerator.generate(@certificate)
      
      filename = smart_filename(@certificate)
      
      send_data pdf_data, 
        filename: filename, 
        type: 'application/pdf', 
        disposition: 'attachment'
    else
      redirect_to public_certificate_path(@certificate.download_token), alert: 'O link de download expirou.'
    end
  end

  private

  def smart_filename(certificate)
    participant_name = certificate.participant.name.parameterize(separator: '_')
    event_name = certificate.event.title.parameterize(separator: '_').truncate(30, omission: '')
    uuid_short = certificate.uuid.split('-').first
    
    "Certificado_#{participant_name}_#{event_name}_#{uuid_short}.pdf"
  end
end
