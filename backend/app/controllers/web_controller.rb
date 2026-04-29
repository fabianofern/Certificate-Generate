class WebController < ActionController::Base
  protect_from_forgery with: :exception
  
  include RoleManagement
  include Authorization

  layout 'application'
  include Rails.application.routes.url_helpers
  prepend_view_path Rails.root.join('../certificate_templates')
end