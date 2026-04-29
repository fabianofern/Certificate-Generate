class CertificateEmailJob < ApplicationJob
  queue_as :default

  def perform(certificate_id)
    certificate = Certificate.find_by(id: certificate_id)
    return unless certificate

    begin
      # 1. Generate PDF
      pdf_data = CertificateGenerator.generate(certificate)

      # 2. Send email to student
      CertificateMailer.certificate_email(certificate, pdf_data).deliver_now
      
      # Log success for student
      certificate.email_logs.create!(
        recipient: certificate.participant.email,
        event_type: 'delivery',
        status: 'success',
        details: 'Email enviado ao aluno com sucesso.'
      )

      # 3. Send BCC to instructor
      if certificate.event.instructor_email.present?
        CertificateMailer.bcc_email(certificate, pdf_data).deliver_now
        
        # Log success for instructor
        certificate.email_logs.create!(
          recipient: certificate.event.instructor_email,
          event_type: 'bcc_delivery',
          status: 'success',
          details: 'Cópia enviada ao instrutor com sucesso.'
        )
      end

      # Mark certificate as sent
      certificate.update!(sent_at: Time.current)
      
      # If the model has a sent_status field (mentioned in prompt03), update it
      if certificate.respond_to?(:sent_status=)
        certificate.update!(sent_status: 'sent')
      end

    rescue => e
      # Log failure
      certificate.email_logs.create!(
        recipient: certificate.participant.email,
        event_type: 'delivery',
        status: 'failed',
        error_message: e.message,
        details: e.backtrace.first(3).join("\n")
      )
      
      if certificate.respond_to?(:sent_status=)
        certificate.update!(sent_status: 'failed')
      end

      # Re-raise the error so Sidekiq can retry
      raise e
    end
  end
end
