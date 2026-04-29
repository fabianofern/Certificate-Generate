module Authorization
  extend ActiveSupport::Concern

  included do
    # Helpers para serem chamados como before_action
  end

  private

  def authorize_admin!
    unless admin?
      redirect_to root_path, alert: 'Acesso restrito a Administradores.'
    end
  end

  def authorize_management!
    if visualizador?
      redirect_to student_area_dashboard_path, alert: 'Acesso restrito. Você foi redirecionado para a Área do Aluno.'
    end
  end

  def authorize_viewer!
    unless visualizador?
      redirect_to root_path, alert: 'Administradores e Operadores devem usar o painel administrativo.'
    end
  end

  def require_viewer_login!
    if visualizador? && session[:student_id].blank?
      redirect_to student_area_login_path, alert: 'Por favor, informe seus dados para acessar seus certificados.'
    end
  end
end
