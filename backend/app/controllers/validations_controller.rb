class ValidationsController < WebController
  # Pula validação de CSRF se for apenas uma leitura via GET
  skip_before_action :verify_authenticity_token, only: [:show]

  # GET /validate?data=
  def show
    @qr_data = params[:data]

    if @qr_data.present?
      begin
        @certificate_info = JSON.parse(@qr_data)
      rescue JSON::ParserError
        @error = "O código QR é inválido ou está corrompido."
      end
    end
    
    # Renderiza o layout vazio para validação offline/simples
    render layout: 'application'
  end
end
