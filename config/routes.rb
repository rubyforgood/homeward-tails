Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letters" if Rails.env.development?

  # Authentication
  devise_for :users, controllers: {
    registrations: "registrations",
    sessions: "users/sessions",
    invitations: "organizations/staff/invitations"
  }

  # Application Scope
  resources :country_states, only: [:index]

  root "root#index"
  get "/up", to: "root#up" # Health check endpoint to let Kamal know the app is up
  get "/about_us", to: "static_pages#about_us"
  get "/partners", to: "static_pages#partners"
  get "/donate", to: "static_pages#donate"
  get "/privacy_policy", to: "static_pages#privacy_policy"
  get "/terms_and_conditions", to: "static_pages#terms_and_conditions"
  get "/cookie_policy", to: "static_pages#cookie_policy"

  # Contact Forms
  resources :contacts, only: %i[new create]
  resource :organization_account_request, only: %i[new create]
  resources :feedback, only: %i[new create]

  # Organization Scope
  scope module: :organizations do
    # Public Routes
    resources :home, only: [:index]
    resources :adoptable_pets, only: %i[index show]
    resources :faq, only: [:index]

    # Staff Routes
    namespace :staff do
      resource :organization, only: %i[edit update]
      resources :staff, only: %i[index]
      resource :custom_page, only: %i[edit update]
      resources :external_form_upload, only: %i[index create]
      resources :default_pet_tasks
      resources :faqs
      resources :matches, only: %i[create destroy]
      resources :adoption_application_reviews, only: %i[index edit update]
      resources :manage_fosters, only: %i[new create index edit update destroy]
      resources :fosterers, only: %i[index edit update]
      resources :adopters, only: %i[index]
      resources :staff_invitations, only: %i[new]
      resources :fosterer_invitations, only: %i[new]
      post "user_roles/:id/to_admin", to: "user_roles#to_admin", as: "user_to_admin"
      post "user_roles/:id/to_super_admin", to: "user_roles#to_super_admin", as: "user_to_super_admin"

      resources :pets do
        resources :tasks
        post "attach_images", on: :member, to: "pets#attach_images"
        post "attach_files", on: :member, to: "pets#attach_files"
      end

      resources :dashboard, only: [:index] do
        collection do
          get :pets_with_incomplete_tasks
          get :pets_with_overdue_tasks
        end
      end

      resources :people do
        resources :form_submissions, only: [:index]
      end

      resources :people do
        resources :form_submissions, only: [:index]
      end

      resources :form_submissions do
        resources :form_answers, only: [:index]
      end

      resources :adoption_application_reviews, only: %i[index edit update]
      resources :manage_fosters, only: %i[new create index edit update destroy]
      resources :fosterers, only: %i[index edit update]
      resources :adopters, only: %i[index]
      resources :form_submissions do
        resources :form_answers, only: [:index]
      end

      namespace :custom_form do
        resources :forms do
          resources :questions
        end
      end
    end

    # Adopter and Fosterer Routes
    namespace :adopter_fosterer do
      resources :faq, only: [:index]
      resources :donations, only: [:index]
      resources :dashboard, only: [:index]
      resources :likes, only: [:index, :create, :destroy]
      resources :adopter_applications, path: "applications", only: %i[index create update]
      resources :external_form, only: %i[index]
      resources :form_answers, only: %i[index]

      resources :adopted_pets, only: [:index] do
        resources :files, only: [:index], module: :adopted_pets
        resources :tasks, only: [:index], module: :adopted_pets
      end

      resources :fostered_pets, only: [:index] do
        resources :files, only: [:index], module: :fostered_pets
        resources :tasks, only: [:index], module: :fostered_pets
      end
    end

    # Activate/Deactivate users
    resource :activations, only: [:update]

    # File Purging
    delete "staff/attachments/:id/purge", to: "attachments#purge", as: "staff_purge_attachment"
    delete "attachments/:id/purge_avatar", to: "attachments#purge_avatar", as: "purge_avatar"
  end
end
