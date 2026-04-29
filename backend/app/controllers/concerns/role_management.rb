module RoleManagement
  extend ActiveSupport::Concern

  ADMINISTRADOR = 'administrador'.freeze
  OPERADOR = 'operador'.freeze
  VISUALIZADOR = 'visualizador'.freeze

  included do
    helper_method :current_role, :admin?, :operador?, :visualizador?, :can_delete?, :can_manage_settings?
    before_action :set_role_from_params
  end

  def current_role
    # No futuro, isso virá do JWT do ToolCenter.
    # Por enquanto, usamos a sessão.
    session[:role] ||= ADMINISTRADOR # Padrão para desenvolvimento MVP
    session[:role]
  end

  def admin?
    current_role == ADMINISTRADOR
  end

  def operador?
    current_role == OPERADOR
  end

  def visualizador?
    current_role == VISUALIZADOR
  end

  def can_delete?
    admin?
  end

  def can_manage_settings?
    admin?
  end

  private

  def set_role_from_params
    # Permite simular papéis via URL durante o desenvolvimento (?role=operador)
    if params[:role].present? && [ADMINISTRADOR, OPERADOR, VISUALIZADOR].include?(params[:role])
      session[:role] = params[:role]
    end
  end
end
