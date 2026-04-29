class ApplicationController < ActionController::API
  before_action :authenticate_api_request!

  private

  def authenticate_api_request!
    # PREPARAÇÃO PARA JWT DO TOOLCENTER
    # 
    # auth_header = request.headers['Authorization']
    # token = auth_header.split(' ').last if auth_header
    # 
    # begin
    #   decoded_token = JWT.decode(token, ENV['JWT_SECRET'], true, algorithm: 'HS256')
    #   @current_api_role = decoded_token[0]['role']
    # rescue JWT::DecodeError
    #   render json: { error: 'Token inválido ou ausente' }, status: :unauthorized
    # end
    
    # Simulação para desenvolvimento enquanto não há JWT:
    @current_api_role = request.headers['X-Role-Simulation'] || RoleManagement::ADMINISTRADOR
  end

  def api_admin?
    @current_api_role == RoleManagement::ADMINISTRADOR
  end

  def api_operador?
    @current_api_role == RoleManagement::OPERADOR
  end

  def api_visualizador?
    @current_api_role == RoleManagement::VISUALIZADOR
  end

  def authorize_api_management!
    if api_visualizador?
      render json: { error: 'Acesso negado para visualizadores' }, status: :forbidden
    end
  end

  def authorize_api_admin!
    unless api_admin?
      render json: { error: 'Acesso restrito a administradores' }, status: :forbidden
    end
  end
end
