class CsvImportJob < ApplicationJob
  queue_as :default

  def perform(blob_signed_id, current_user_id, current_organization_id)
    blob = ActiveStorage::Blob.find_signed(blob_signed_id)
    org = Organization.find(current_organization_id)

    Organizations::Importers::CsvImportService.new(blob, org).call
  ensure
    blob.purge_later
  end
end
