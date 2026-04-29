class SessionsController < WebController
  # Ignora autorizações para as telas de login
  skip_before_action :set_role_from_params, only: [:set_role, :process_student_login]

  def select_role
    # Tela de seleção de perfil para MVP
  end

  def set_role
    if [RoleManagement::ADMINISTRADOR, RoleManagement::OPERADOR, RoleManagement::VISUALIZADOR].include?(params[:role])
      session[:role] = params[:role]
      
      if params[:role] == RoleManagement::VISUALIZADOR
        redirect_to student_login_path, notice: 'Perfil Visualizador selecionado. Por favor, identifique-se.'
      else
        redirect_to root_path, notice: "Perfil alterado para #{params[:role].capitalize}."
      end
    else
      redirect_to select_role_path, alert: 'Perfil inválido.'
    end
  end

  def student_login
    # Tela de login simples do aluno
    redirect_to student_area_dashboard_path if session[:student_id].present?
  end

  def process_student_login
    email = params[:email].to_s.strip.downcase
    cpf = params[:cpf].to_s.strip.gsub(/\D/, '')

    if email.blank? || cpf.blank?
      flash.now[:alert] = 'Por favor, informe e-mail e CPF.'
      render :student_login, status: :unprocessable_entity
      return
    end

    participant = Participant.find_by(email: email, cpf: cpf)

    if participant
      session[:student_id] = participant.id
      session[:role] = RoleManagement::VISUALIZADOR
      redirect_to student_area_dashboard_path, notice: "Bem-vindo, #{participant.name}!"
    else
      flash.now[:alert] = 'Dados não encontrados. Verifique seu e-mail e CPF.'
      render :student_login, status: :unprocessable_entity
    end
  end

  def logout
    session.delete(:role)
    session.delete(:student_id)
    redirect_to select_role_path, notice: 'Sessão encerrada com sucesso.'
  end
end
