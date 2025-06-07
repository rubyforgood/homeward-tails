module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    include OrganizationScopable

    def google_oauth2
      @user = User.from_omniauth(request.env["omniauth.auth"])
      if @user.persisted?
        # Check if this is a new user (just created) or existing user
        if @user.created_at > 1.minute.ago
          # New user - redirect to TOS agreement
          sign_in(@user)
          redirect_to edit_tos_agreement_path
        else
          # Existing user - sign them in normally
          sign_in_and_redirect @user, event: :authentication
        end
        set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
      else
        # User creation failed, redirect to registration
        session["devise.google_data"] = request.env["omniauth.auth"].except(:extra)
        redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
      end
    end

    def failure
      redirect_to root_path
    end

    private

    def after_omniauth_success_path_for(resource)
      if resource.person_in_current_org.present?
        stored_location_for(resource) || root_path
      else
        edit_tos_agreement_path
      end
    end
  end
end
