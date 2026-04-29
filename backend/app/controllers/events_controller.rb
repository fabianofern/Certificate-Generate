class EventsController < WebController
  before_action :authorize_management!
  before_action :authorize_admin!, only: [:destroy]
  before_action :set_event, only: [:show, :edit, :update, :destroy, :generate_certificates, :certificates, :send_all_certificates]

  def index
    @events = Event.all.order(created_at: :desc)
  end

  def show
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      redirect_to @event, notice: 'Evento criado com sucesso!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: 'Evento atualizado com sucesso!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, notice: 'Evento excluído com sucesso!'
  end

  def generate_certificates
    participant_ids = params[:participant_ids] || []

    if participant_ids.blank?
      redirect_to @event, alert: 'Selecione pelo menos um participante.'
      return
    end

    count = 0
    participant_ids.each do |participant_id|
      participant = Participant.find_by(id: participant_id)
      next unless participant

      certificate = Certificate.find_or_initialize_by(event: @event, participant: participant)
      if certificate.new_record?
        certificate.save!
        count += 1
      end
    end

    redirect_to @event, notice: "#{count} certificado(s) gerado(s) com sucesso!"
  rescue ActiveRecord::RecordInvalid => e
    redirect_to @event, alert: "Erro: #{e.message}"
  end

  def certificates
    @certificates = @event.certificates.includes(:participant)
  end

  def send_all_certificates
    # Busca todos os certificados pendentes deste evento
    pending_certificates = @event.certificates.where(sent_at: nil)
    
    if pending_certificates.empty?
      redirect_to @event, notice: 'Nenhum certificado pendente de envio.'
      return
    end

    count = 0
    pending_certificates.each do |certificate|
      CertificateEmailJob.perform_later(certificate.id)
      count += 1
    end

    redirect_to @event, notice: "#{count} certificado(s) adicionado(s) à fila de envio."
  end

  private

  def set_event
    @event = Event.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to events_path, alert: 'Evento não encontrado.'
  end

  def event_params
    params.require(:event).permit(
      :title,
      :workload,
      :start_date,
      :end_date,
      :location,
      :instructor_name,
      :instructor_email,
      :template_name
    )
  end
end