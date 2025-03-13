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

        if notable_type.present? && notable_id.present?
          klass = notable_type.constantize
          @notable = klass.find(notable_id)
        else
          raise ActionController::ParameterMissing, "Missing notable_type or notable_id parameters"
        end
      end

      def note_params
        params.permit(:notes, :notable_id, :notable_type)
      end
    end
  end
end
