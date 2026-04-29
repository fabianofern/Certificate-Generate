class DashboardController < WebController
  def index
    if visualizador?
      redirect_to student_area_dashboard_path
    elsif operador?
      render 'operator'
    else
      # Administrador ou fallback (desenvolvimento)
      render 'admin'
    end
  end

  # Métodos auxiliares para carregar dados do dashboard
  helper_method :total_events, :total_participants, :certificates_generated, 
                :certificates_sent, :recent_events, :pending_certificates, 
                :activity_data, :sent_percentage

  private

  def total_events
    @total_events ||= Event.count
  end

  def total_participants
    @total_participants ||= Participant.count
  end

  def certificates_generated
    @certificates_generated ||= Certificate.count
  end

  def certificates_sent
    @certificates_sent ||= Certificate.sent.count
  end

  def sent_percentage
    return 0 if certificates_generated == 0
    ((certificates_sent.to_f / certificates_generated) * 100).round(1)
  end

  def recent_events
    @recent_events ||= Event.order(created_at: :desc).limit(5)
  end

  def pending_certificates
    @pending_certificates ||= Certificate.pending.includes(:event, :participant).order(created_at: :desc).limit(10)
  end

  def activity_data
    return @activity_data if @activity_data

    days_list = (0..6).to_a.reverse.map { |i| i.days.ago.to_date }
    sent_by_day = days_list.map { |day| Certificate.sent.where('DATE(sent_at) = ?', day).count }
    pending_by_day = days_list.map { |day| Certificate.pending.where('DATE(created_at) = ?', day).count }

    @activity_data = {
      days: days_list,
      sent_by_day: sent_by_day,
      pending_by_day: pending_by_day
    }
  end
end
