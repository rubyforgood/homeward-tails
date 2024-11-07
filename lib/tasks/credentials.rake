# Added to get the value of a specific credential from the credentials.yml.enc file
# for deployment purposes.
namespace :credentials do
  desc "Read a specific credential"
  task read: :environment do
    key_path = ENV['KEY'].to_s.split(',').map(&:to_sym)
    value = Rails.application.credentials.dig(*key_path)
    puts value
  end
end
