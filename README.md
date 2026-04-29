# Certificate Generate 🏆

Sistema SaaS profissional para gerenciamento de eventos e emissão automatizada de certificados com validação via QR Code.

## 🚀 Sobre o Projeto

O **Certificate Generate** é uma plataforma robusta desenvolvida para organizadores de eventos, workshops e palestras que precisam de uma solução ágil e segura para emitir certificados. O sistema permite o controle total desde o cadastro de participantes até o envio em massa por e-mail, contando com um mecanismo de validação de autenticidade.

## ✨ Funcionalidades Principais

- **Gestão de Eventos**: Cadastro completo com título, carga horária, instrutor e período (data início/fim).
- **Controle de Participantes**: Importação de planilhas e gestão individual de dados (Nome, E-mail, CPF).
- **Emissão Automatizada**: Geração de PDFs profissionais em massa ou individualmente.
- **Segurança e Validação**:
    - Cada certificado possui um UUID único.
    - QR Code integrado para validação instantânea da autenticidade.
- **Controle de Acesso (RBAC)**:
    - **Administrador**: Gestão total do sistema e configurações.
    - **Operador**: Gestão de eventos e emissão de certificados.
    - **Área do Aluno**: Consulta de certificados próprios através do CPF.
- **Comunicação**: Envio automático de certificados por e-mail via processos em segundo plano.

## 🛠️ Tecnologias Utilizadas

- **Backend**: Ruby on Rails 7
- **Banco de Dados**: PostgreSQL / SQLite
- **Geração de PDF**: Prawn
- **QR Codes**: RQRCode
- **Processamento**: Sidekiq & Redis
- **Frontend**: Bootstrap 5 & Vanilla JS (Design Premium)

## 📋 Pré-requisitos

- Ruby 3.2+
- Rails 7.1+
- PostgreSQL (opcional para produção)
- Redis (para filas de e-mail)

## 🔧 Instalação e Execução

1. **Clonar o repositório**:
   ```bash
   git clone https://github.com/fabianofern/Certificate-Generate.git
   cd "Certificate Generate"
   ```

2. **Configurar o Backend**:
   ```bash
   cd backend
   bundle install
   rails db:create db:migrate
   ```

3. **Iniciar o Servidor**:
   ```bash
   rails server
   ```

4. **Iniciar o Worker (Opcional para E-mails)**:
   ```bash
   bundle exec sidekiq
   ```

Acesse o sistema em: `http://localhost:3000`

## 📁 Estrutura do Projeto

```text
Certificate Generate/
├── backend/                # Aplicação Ruby on Rails (API e Views)
├── certificate_templates/  # Definições de layouts de certificados
├── .agent/                 # Configurações de Agentes de IA e Workflows
└── README.md               # Documentação principal
```

---
Desenvolvido com foco em escalabilidade e facilidade de uso. 🚀
