module Organizations
  module Staff
    module CustomForm
      class QuestionsController < ApplicationController
        before_action :context_authorize!
        before_action :set_form
        before_action :set_question, only: %i[edit update destroy]

        layout "dashboard"

        def index
          @questions = authorized_scope(@form.questions)
        end

        def new
          @question = @form.questions.new
        end

        def create
          @question = @form.questions.new(question_params)

          if @question.save
            redirect_to staff_custom_form_form_path(@form), notice: t(".success")
          else
            flash.now[:alert] = t(".error")

            render :new, status: :unprocessable_entity
          end
        end

        def edit
        end

        def update
          if @question.update(question_params)
            redirect_to staff_custom_form_form_path(@form), notice: t(".success")
          else
            flash.now[:alert] = t(".error")

            render :edit, status: :unprocessable_entity
          end
        end

        def destroy
          @question.destroy

          redirect_to staff_custom_form_form_path(@form), notice: t(".success")
        end

        private

        def organization
          Current.organization
        end

        def set_form
          @form = organization.forms.find(params[:form_id])
          authorize! @form
        rescue ActiveRecord::RecordNotFound
          redirect_to staff_custom_form_forms_path, alert: t("organizations.staff.custom_form.forms.not_found")
        end

        def set_question
          @question = @form.questions.find(params[:id])
          authorize! @question
        rescue ActiveRecord::RecordNotFound
          redirect_to staff_custom_form_form_path(@form), alert: t(".not_found")
        end

        def question_params
          params.require(:custom_form_question).permit(:name, :description, :label, :help_text, :required, :input_type, :options)
        end

        def context_authorize!
          authorize! ::CustomForm::Question, context: {organization: Current.organization}
        end
      end
    end
  end
end
