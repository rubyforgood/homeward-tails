class CsvImportJob < ApplicationJob
  queue_as :default

  def perform(blob_signed_id, current_user_id)
    blob = ActiveStorage::Blob.find_signed(blob_signed_id)

    Organizations::Importers::CsvImportService.new(blob, current_user_id).call
  ensure
    blob.purge_later
  end
end
