class ParticipantsController < WebController
  before_action :authorize_management!
  before_action :authorize_admin!, only: [:destroy]
  before_action :set_participant, only: %i[ show edit update destroy generate_certificate toggle_active ]

  # GET /participants
  def index
    # Filtro de status: padrão é mostrar apenas os ativos.
    @status_filter = params[:status] || 'active'
    
    @participants = if @status_filter == 'all'
                      Participant.all
                    else
                      Participant.active
                    end
    
    @participants = @participants.includes(:certificates)
    
    if params[:name].present?
      @participants = @participants.where("name LIKE ?", "%#{params[:name].strip}%")
    end

    if params[:email].present?
      @participants = @participants.where("email LIKE ?", "%#{params[:email].strip}%")
    end

    if params[:cpf].present?
      @participants = @participants.where("cpf LIKE ?", "%#{params[:cpf].strip.gsub(/\D/, '')}%")
    end

    if params[:registration].present?
      @participants = @participants.where("registration LIKE ?", "%#{params[:registration].strip}%")
    end

    if params[:event_ids].present? && params[:event_ids].reject(&:blank?).any?
      @participants = @participants.joins(:certificates).where(certificates: { event_id: params[:event_ids] }).distinct
    end

    @participants = @participants.order(name: :asc)
    @events = Event.all.order(title: :asc)

    respond_to do |format|
      format.html
      format.csv { send_data generate_csv(@participants), filename: "participantes-#{Date.today}.csv" }
    end
  end

  # GET /participants/1
  def show
    @certificates = @participant.certificates.includes(:event)
  end

  # GET /participants/new
  def new
    @participant = Participant.new
  end

  # GET /participants/1/edit
  def edit
  end

  # POST /participants
  def create
    @participant = Participant.new(participant_params)

    if @participant.save
      redirect_to @participant, notice: "Participante criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /participants/1
  def update
    if @participant.update(participant_params)
      redirect_to @participant, notice: "Participante atualizado com sucesso.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /participants/1
  def destroy
    @participant.destroy!
    redirect_to participants_url, notice: "Participante excluído com sucesso.", status: :see_other
  end

  # GET/POST /participants/import
  def import
    if request.post?
      file = params[:file]
      if file.nil?
        redirect_to import_participants_path, alert: "Por favor, selecione um arquivo."
        return
      end

      begin
        spreadsheet = open_spreadsheet(file)
        header = spreadsheet.row(1).map(&:to_s).map(&:strip).map(&:downcase)
        
        imported_count = 0
        errors = []

        (2..spreadsheet.last_row).each do |i|
          row_data = spreadsheet.row(i)
          next if row_data.compact.empty? # Skip empty rows

          row = Hash[[header, row_data].transpose]
          
          email = row["email"]&.strip
          name = (row["nome"] || row["name"])&.strip
          cpf = row["cpf"]&.to_s&.strip
          registration = (row["matricula"] || row["matrícula"] || row["registration"])&.to_s&.strip

          if email.blank?
            errors << "Linha #{i}: Email não pode ficar em branco"
            next
          end

          participant = Participant.find_or_initialize_by(email: email)
          participant.name = name if name.present?
          participant.cpf = cpf if cpf.present?
          participant.registration = registration if registration.present?
          
          if participant.save
            imported_count += 1
          else
            errors << "Linha #{i} (#{email}): #{participant.errors.full_messages.join(', ')}"
          end
        end

        if errors.any?
          flash[:alert] = "Importação concluída com #{imported_count} sucessos. Alguns erros ocorreram: #{errors.first(5).join('; ')}#{'...' if errors.size > 5}"
        else
          flash[:notice] = "#{imported_count} participantes importados com sucesso."
        end
        redirect_to participants_path
      rescue => e
        redirect_to import_participants_path, alert: "Erro ao processar arquivo: #{e.message}"
      end
    end
  end

  # POST /participants/1/generate_certificate
  def generate_certificate
    event = Event.find(params[:event_id])
    
    # Força a associação correta
    certificate = Certificate.find_or_initialize_by(event: event, participant: @participant)
    
    if certificate.new_record?
      certificate.save!
      redirect_to event, notice: "Certificado gerado com sucesso para #{@participant.name}."
    else
      redirect_to event, alert: "Este participante já possui um certificado para este evento."
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to @participant, alert: "Evento não encontrado."
  end

  # PATCH /participants/1/toggle_active
  def toggle_active
    @participant.update(active: !@participant.active)
    
    status_msg = @participant.active ? "ativado" : "inativado"
    redirect_back fallback_location: participants_path, notice: "Participante #{status_msg} com sucesso."
  end

  private
    def set_participant
      @participant = Participant.find(params[:id])
    end

    def participant_params
      params.require(:participant).permit(:name, :email, :cpf, :registration, :active)
    end

    def generate_csv(participants)
      require 'csv'
      CSV.generate(headers: true, col_sep: ";") do |csv|
        csv << ["Nome", "Email", "CPF", "Matricula", "Certificados"]
        participants.each do |p|
          csv << [p.name, p.email, p.cpf, p.registration, p.certificates.count]
        end
      end
    end

    def open_spreadsheet(file)
      case File.extname(file.original_filename)
      when ".csv" then Roo::CSV.new(file.path)
      when ".xls" then Roo::Excel.new(file.path)
      when ".xlsx" then Roo::Excelx.new(file.path)
      else raise "Tipo de arquivo desconhecido: #{file.original_filename}"
      end
    end
end
