class CertificateMailer < ApplicationMailer
  default from: 'noreply@certificategenerator.com'

  def certificate_email(certificate, pdf_data)
    @certificate = certificate
    @participant = certificate.participant
    @event = certificate.event

    attachments["certificado_#{@certificate.uuid}.pdf"] = {
      mime_type: 'application/pdf',
      content: pdf_data
    }

    mail(to: @participant.email, subject: "Seu certificado de #{@event.title}")
  end

  def bcc_email(certificate, pdf_data)
    @certificate = certificate
    @participant = certificate.participant
    @event = certificate.event

    attachments["certificado_#{@certificate.uuid}.pdf"] = {
      mime_type: 'application/pdf',
      content: pdf_data
    }

    mail(to: @event.instructor_email, subject: "Cópia: Certificado de #{@participant.name} (#{@event.title})")
  end
end
