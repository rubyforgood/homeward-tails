module Organizations
  module Staff
    class NotesController < ApplicationController
      before_action :set_note, only: [:update]

      def update
        respond_to do |format|
          if @note.update(note_params)
            format.html { redirect_to staff_dashboard_index_path, notice: t(".success") }
            format.turbo_stream { flash.now[:notice] = t(".success") }
          else
            format.html { render :edit, status: :unprocessable_entity }
            format.turbo_stream { flash.now[:alert] = t(".error") }
          end
        end
      end

      private

      def set_note
        @note = Note.find(params[:id])
        authorize! @note
      end

      def note_params
        params.require(:note).permit(:notes)
      end
    end
  end
end