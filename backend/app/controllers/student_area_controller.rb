class StudentAreaController < WebController
  layout 'student'
  
  before_action :authorize_viewer!
  before_action :require_viewer_login!
  before_action :set_participant

  def dashboard
    @certificates = @participant.certificates.includes(:event).order(created_at: :desc)
  end

  def show_certificate
    @certificate = @participant.certificates.find_by!(uuid: params[:uuid])
    @qr_code = RQRCode::QRCode.new(@certificate.qr_code_data)
  end

  private

  def set_participant
    @participant = Participant.find(session[:student_id])
  rescue ActiveRecord::RecordNotFound
    session.delete(:student_id)
    redirect_to student_login_path, alert: 'Sessão inválida. Por favor, acesse novamente.'
  end
end
