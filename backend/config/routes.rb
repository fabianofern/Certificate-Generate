Rails.application.routes.draw do
  # Rotas Web (interface HTML)
  resources :events do
    member do
      post :generate_certificates
      get :certificates
      post :send_all_certificates
    end
  end

  resources :participants do
    collection do
      get :import
      post :import
    end
    member do
      post :generate_certificate
    end
  end

  resources :certificates, only: [:index, :show, :destroy] do
    member do
      post :resend_email
      get :download
    end
  end

  # Rota de validação offline
  get '/validate', to: 'validations#show'

  # Link público de download (expira em 7 dias)
  get '/c/:token', to: 'public_certificates#show', as: :public_certificate
  get '/c/:token/download', to: 'public_certificates#download', as: :download_public_certificate

  # Raiz do site: roteamento inteligente por perfil
  root 'dashboard#index'

  # Sistema de Sessões e Perfis (MVP)
  get '/selecionar-perfil', to: 'sessions#select_role', as: :select_role
  post '/selecionar-perfil', to: 'sessions#set_role', as: :set_role
  delete '/sair', to: 'sessions#logout', as: :logout

  # Área do Aluno (Visualizador)
  get '/area-do-aluno/login', to: 'sessions#student_login', as: :student_login
  post '/area-do-aluno/login', to: 'sessions#process_student_login', as: :process_student_login
  
  namespace :student_area, path: 'area-do-aluno' do
    get '/meus-certificados', to: 'student_area#dashboard', as: :dashboard
    get '/certificados/:uuid', to: 'student_area#show_certificate', as: :certificate
  end
  # Rotas API (JSON para integração futura com ToolCenter)
  namespace :api do
    namespace :v1 do
      resources :events, only: [:index, :show, :create, :update, :destroy] do
        member do
          post :generate_certificates
          get :certificates
        end
      end

      resources :participants, only: [:index, :show, :create, :update, :destroy] do
        collection do
          post :import
        end
      end

      resources :certificates, only: [:index, :show, :destroy] do
        member do
          post :resend_email
          get :download
        end
      end
    end
  end
end