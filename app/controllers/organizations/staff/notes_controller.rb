module Organizations
  module Staff
    class NotesController < StaffController
      before_action :set_notable

      def update
        note = @notable.note || @notable.build_note
        authorize! note, with: Organizations::NotePolicy

        if @notable.note.present?
          @notable.note.update(note_params)
        else
          @notable.create_note(note_params)
        end

        @context = params[:context] || "default"

        respond_to do |format|
          format.html { redirect_back(fallback_location: root_path, notice: t("organizations.staff.notes.update.success")) }
          format.turbo_stream { flash.now[:notice] = t(".success") }
        end
      end

      private

      def set_notable
        notable_type = params[:notable_type]
        notable_id = params[:notable_id]

        if notable_type.blank? || notable_id.blank?
          raise ActionController::ParameterMissing.new("Missing notable_type or notable_id parameters")
        end

        case notable_type
        when "AdopterApplication"
          @notable = AdopterApplication.find(notable_id)
        when "Person"
          @notable = Person.find(notable_id)
        else
          raise ActionController::BadRequest.new("Invalid notable_type parameter")
        end
      rescue ActiveRecord::RecordNotFound
        raise ActionController::BadRequest.new("Resource not found")
      end

      def note_params
        params.permit(:notes, :notable_id, :notable_type)
      end
    end
  end
end
