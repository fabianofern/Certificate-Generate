class StaticPagesController < WebController
  def dashboard
    @total_events = Event.count
    @total_participants = Participant.count
    @certificates_generated = Certificate.count
    @certificates_sent = Certificate.sent.count
    
    @sent_percentage = @certificates_generated > 0 ? (@certificates_sent.to_f / @certificates_generated * 100).round(1) : 0
    
    @recent_events = Event.order(created_at: :desc).limit(5)
    @pending_certificates = Certificate.pending.includes(:event, :participant).order(created_at: :desc).limit(10)
    
    # Dados para o gráfico (últimos 7 dias)
    @days = (0..6).to_a.reverse.map { |i| i.days.ago.to_date }
    @sent_by_day = @days.map { |day| Certificate.sent.where('DATE(sent_at) = ?', day).count }
    @pending_by_day = @days.map { |day| Certificate.pending.where('DATE(created_at) = ?', day).count }
  end
end
