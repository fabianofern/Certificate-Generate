require 'prawn'

class CertificateGenerator
  def self.generate(certificate)
    pdf = Prawn::Document.new(
      page_size: 'A4',
      page_layout: :landscape,
      margin: [40, 40, 40, 40]
    )

    # Configuração de cores baseada no template
    is_custom = certificate.event.template_name == 'custom'
    primary_color = is_custom ? "1a237e" : "333333"
    accent_color = is_custom ? "c2185b" : "764ba2"
    border_color = is_custom ? "c2185b" : "667eea"

    pdf.canvas do
      # Borda decorativa
      pdf.line_width = is_custom ? 15 : 10
      pdf.stroke_color border_color
      pdf.stroke_bounds
      
      if is_custom
        # Segunda borda interna para o customizado
        pdf.line_width = 1
        pdf.stroke_color "eeeeee"
        pdf.stroke_rectangle [10, pdf.bounds.height - 10], pdf.bounds.width - 20, pdf.bounds.height - 20
      end

      pdf.line_width = 2
      pdf.stroke_color accent_color
      pdf.stroke_rectangle [15, pdf.bounds.height - 15], pdf.bounds.width - 30, pdf.bounds.height - 30
    end

    pdf.move_down 60

    # Título
    pdf.font "Helvetica", style: :bold
    pdf.fill_color primary_color
    pdf.text "CERTIFICADO DE CONCLUSÃO", size: 40, align: :center

    pdf.move_down 40

    # Texto principal
    pdf.font "Helvetica", style: :normal
    pdf.fill_color primary_color
    pdf.text "Certificamos que", size: 18, align: :center
    
    pdf.move_down 20
    pdf.font "Helvetica", style: :bold
    pdf.fill_color accent_color
    pdf.text certificate.participant.name.upcase, size: 30, align: :center
    
    pdf.move_down 20
    pdf.font "Helvetica", style: :normal
    pdf.text "concluiu com êxito o curso/palestra", size: 18, align: :center
    
    pdf.move_down 15
    pdf.font "Helvetica", style: :bold
    pdf.text certificate.event.title, size: 22, align: :center
    
    pdf.move_down 40

    # Detalhes em colunas
    pdf.column_box([50, pdf.cursor], columns: 2, width: pdf.bounds.width - 100) do
      pdf.font "Helvetica", size: 12
      pdf.text "<b>Carga Horária:</b> #{certificate.event.workload} horas", inline_format: true
      pdf.text "<b>Período:</b> #{certificate.event.period}", inline_format: true
      pdf.text "<b>Local:</b> #{certificate.event.location}", inline_format: true
      
      pdf.move_down 10
      
      pdf.text "<b>Instrutor:</b> #{certificate.event.instructor_name}", inline_format: true
      pdf.text "<b>Emissão:</b> #{certificate.created_at.strftime('%d/%m/%Y')}", inline_format: true
    end

    # QR Code e Autenticação no canto inferior direito
    pdf.float do
      qr_code = RQRCode::QRCode.new(certificate.qr_code_data)
      modules = qr_code.qrcode.modules
      module_size = 1.5 # Reduzido para ser mais discreto
      
      # Posicionamento no canto inferior direito (mais para a esquerda e sem texto debaixo)
      qr_x = pdf.bounds.width - 180
      qr_y = 150
      
      pdf.fill_color "000000"
      modules.each_with_index do |row, i|
        row.each_with_index do |col, j|
          if col
            pdf.fill_rectangle [qr_x + (j * module_size), qr_y - (i * module_size)], module_size, module_size
          end
        end
      end
    end

    # Rodapé / UUID (ID Principal mantido no canto inferior esquerdo)
    pdf.fill_color "999999"
    pdf.draw_text "ID do Certificado: #{certificate.uuid}", at: [50, 20], size: 8

    pdf.render
  end
end
