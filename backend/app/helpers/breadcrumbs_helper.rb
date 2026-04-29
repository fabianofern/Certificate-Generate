module BreadcrumbsHelper
  def render_breadcrumbs
    crumbs = []
    crumbs << link_to('Dashboard', root_path)
    
    case controller_name
    when 'events'
      crumbs << link_to('Eventos', events_path)
      crumbs << @event.title if action_name == 'show' && @event&.persisted?
      crumbs << 'Novo Evento' if action_name == 'new'
      crumbs << "Editar #{@event.title}" if action_name == 'edit'
      crumbs << "Certificados: #{@event.title}" if action_name == 'certificates'
    when 'participants'
      crumbs << link_to('Participantes', participants_path)
      crumbs << @participant.name if action_name == 'show' && @participant&.persisted?
      crumbs << 'Novo Participante' if action_name == 'new'
      crumbs << 'Importar' if action_name == 'import'
    when 'certificates'
      crumbs << link_to('Certificados', certificates_path)
      crumbs << "Certificado ##{@certificate.uuid.split('-').first}" if action_name == 'show' && @certificate&.persisted?
    end

    return if crumbs.size <= 1

    content_tag(:nav, aria: { label: 'breadcrumb' }, class: 'mb-4') do
      content_tag(:ol, class: 'breadcrumb bg-white p-3 rounded shadow-sm') do
        crumbs.map.with_index do |crumb, index|
          active = (index == crumbs.size - 1)
          content_tag(:li, class: "breadcrumb-item #{'active' if active}", aria: { current: ('page' if active) }) do
            active ? crumb : crumb
          end
        end.join.html_safe
      end
    end
  end
end
