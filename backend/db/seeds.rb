# Criar um evento de exemplo
event = Event.create!(
  title: 'Workshop de Ruby on Rails',
  workload: 8,
  period: '15/04/2026 a 16/04/2026',
  location: 'São Paulo, SP',
  instructor_name: 'João Silva',
  instructor_email: 'joao.silva@email.com',
  template_name: 'default'
)

# Criar participantes de exemplo
participants = [
  { name: 'Maria Oliveira', email: 'maria@email.com', cpf: '12345678901' },
  { name: 'Carlos Santos', email: 'carlos@email.com', cpf: '98765432109' }
]

participants.each do |attrs|
  participant = Participant.create!(attrs)
  Certificate.create!(event: event, participant: participant)
end

puts "Seed criado com sucesso!"
puts "Evento: #{event.title}"
puts "Participantes: #{Participant.count}"
puts "Certificados: #{Certificate.count}"