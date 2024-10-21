Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "registrations",
    sessions: "users/sessions",
    invitations: "organizations/staff/invitations"
  }

  scope module: :organizations do
    resources :home, only: [:index]
    resources :adoptable_pets, only: %i[index show]
    resources :faq, only: [:index]

    namespace :staff do
      resource :organization, only: %i[edit update]
      resource :custom_page, only: %i[edit update]
      resources :profile_reviews, only: [:show]
      resources :external_form_upload, only: %i[index create]

      resources :pets do
        resources :tasks
        post "attach_images", on: :member, to: "pets#attach_images"
        post "attach_files", on: :member, to: "pets#attach_files"
      end

      resources :default_pet_tasks
      resources :faqs
      resources :dashboard, only: [:index] do
        collection do
          get :pets_with_incomplete_tasks
          get :pets_with_overdue_tasks
        end
      end
      resources :matches, only: %i[create destroy]

      resources :adoption_application_reviews, only: %i[index edit update]
      resources :manage_fosters, only: %i[new create index edit update destroy]
      resources :fosterers, only: %i[index edit update]
      resources :adopters, only: %i[index]
      resources :staff do
        patch "update_activation"
      end

      resources :staff_invitations, only: %i[new]
      resources :fosterer_invitations, only: %i[new]

      namespace :custom_form do
        resources :forms do
          resources :questions
        end
      end
      post "user_roles/:id/to_admin", to: "user_roles#to_admin", as: "user_to_admin"
      post "user_roles/:id/to_super_admin", to: "user_roles#to_super_admin", as: "user_to_super_admin"
    end
    delete "staff/attachments/:id/purge", to: "attachments#purge", as: "staff_purge_attachment"
    delete "attachments/:id/purge_avatar", to: "attachments#purge_avatar", as: "purge_avatar"

    namespace :adopter_fosterer do
      resource :profile, except: :destroy
      resources :faq, only: [:index]
      resources :donations, only: [:index]
      resources :dashboard, only: [:index]
      resources :likes, only: [:index, :create, :destroy]
      resources :adopter_applications, path: "applications", only: %i[index create update]
      resources :adopted_pets, only: [:index] do
        resources :files, only: [:index], module: :adopted_pets
        resources :tasks, only: [:index], module: :adopted_pets
      end
      resources :fostered_pets, only: [:index] do
        resources :files, only: [:index], module: :fostered_pets
        resources :tasks, only: [:index], module: :fostered_pets
      end
      resources :external_form, only: %i[index]
    end
  end

  resources :countries, only: [] do
    resources :states, only: [:index]
  end

  match "/404", to: "errors#not_found", via: :all
  match "/422", to: "errors#unprocessable_content", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  root "root#index"
  get "/about_us", to: "static_pages#about_us"
  get "/partners", to: "static_pages#partners"
  get "/donate", to: "static_pages#donate"
  get "/privacy_policy", to: "static_pages#privacy_policy"
  get "/terms_and_conditions", to: "static_pages#terms_and_conditions"
  get "/cookie_policy", to: "static_pages#cookie_policy"

  resources :contacts, only: %i[new create]
  resources :dev_contacts, path: "feedback", only: %i[new create]
end
