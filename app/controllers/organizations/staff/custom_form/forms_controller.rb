module Organizations
  module Staff
    module CustomForm
      class FormsController < Organizations::BaseController
        before_action :context_authorize!
        before_action :set_form, only: %i[show edit update destroy]

        layout "dashboard"

        def index
          @forms = authorized_scope(::CustomForm::Form.all)
        end

        def new
          @form = ::CustomForm::Form.new
        end

        def create
          @form = organization.forms.new(form_params)

          if @form.save
            redirect_to staff_custom_form_forms_path, notice: t(".success")
          else
            flash.now[:alert] = t(".error")

            render :new, status: :unprocessable_entity
          end
        end

        def show
        end

        def edit
        end

        def update
          if @form.update(form_params)
            redirect_to staff_custom_form_forms_path, notice: t(".success")
          else
            render :edit, status: :unprocessable_entity
          end
        end

        def destroy
          @form.destroy

          redirect_to staff_custom_form_forms_path, notice: t(".success")
        end

        private

        def organization
          Current.organization
        end

        def set_form
          @form = organization.forms.find(params[:id])
          authorize! @form
        rescue ActiveRecord::RecordNotFound
          redirect_to staff_custom_form_forms_path, alert: t(".not_found")
        end

        def form_params
          params.require(:custom_form_form).permit(:name, :description, :title, :instructions)
        end

        def context_authorize!
          authorize! ::CustomForm::Form
        end
      end
    end
  end
end
