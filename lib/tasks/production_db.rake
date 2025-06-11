# To connect to the Azure postgres database, the IP address of machine you are connecting with must be whitelisted
#
# Go to the Azure dashboard and open the homewardtails-db resource
# Settings > Networking > Firewall rules
# Click "Add current client IP address" or enter manually

namespace :db do
  desc "Back up the production DB to local /tmp folder"
  task :backup_production_to_local do
    current_time = Time.current.strftime("%Y%m%d%H%M%S")
    backup_filename = "/tmp/#{current_time}.dump"

    db_host = production_credentials(:deploy, :db_host)
    db_user = production_credentials(:deploy, :database_username)
    db_pass = production_credentials(:deploy, :database_password)

    ENV["PGPASSWORD"] = db_pass

    puts "Running pg_dump to #{backup_filename}..."
    system("pg_dump -Fc -v --host=#{db_host} --username=#{db_user} --dbname=postgres -f #{backup_filename}")

    if $?.success?
      puts "Backup successful: #{backup_filename}"
    else
      puts "Backup failed."
    end
  end

  desc "Restore latest production backup to local development database"
  PASSWORD_REPLACEMENT = "123456"

  task restore_production_to_local: :environment do
    if ENV["RAILS_ENV"] == "production"
      raise "You may not run this backup script in production!"
    end

    dump_file = Dir["/tmp/*.dump"].sort.last

    unless dump_file && File.exist?(dump_file)
      puts "No backup file found in /tmp"
      exit 1
    end

    puts "Restoring backup from #{dump_file}..."

    # Load local DB config
    config = Rails.configuration.database_configuration["development"]["primary"]
    db_name = config["database"]
    db_host = config["host"] || "localhost"
    db_username = config["username"]
    db_password = config["password"]

    puts "Dropping and recreating local database..."
    system("bin/rails db:drop")
    system("bin/rails db:create")
    system("bin/rails db:schema:load")

    toc_list = filter_dump_file(dump_file)

    puts "Restoring with pg_restore..."
    system("PGPASSWORD='#{db_password}' pg_restore --clean --no-acl --no-owner -L #{toc_list} -h #{db_host} -d #{db_name} -U #{db_username} #{dump_file}")

    if $?.success?
      puts "Database restored successfully."
    else
      puts "Database restore failed."
    end

    # Update the ar_internal_metadata table to have the correct environment
    # This is needed because attempting to drop the development DB will
    # raise a protected environment error.
    system("bin/rails db:environment:set RAILS_ENV=development")

    puts "Replacing all the passwords with the replacement for ease of use: '#{PASSWORD_REPLACEMENT}'"
    # system("bin/rails db:replace_user_passwords")
    replace_user_passwords
  end
end

private

def production_credentials(*keys)
  @production_credentials ||= ActiveSupport::EncryptedConfiguration.new(
    config_path: Rails.root.join("config", "credentials", "production.yml.enc"),
    key_path: Rails.root.join("config", "credentials", "production.key"),
    env_key: "RAILS_MASTER_KEY",
    raise_if_missing_key: true
  )

  keys.reduce(@production_credentials) { |hash, key| hash[key] }
end

def filter_dump_file(dump_file)
  toc_list = "/tmp/restore.list"

  puts "Filtering out Azure-related extensions and cron schema objects from the dump..."
  system("pg_restore -l #{dump_file} > #{toc_list}") || exit(1)

  filtered_lines = File.readlines(toc_list).reject do |line|
    line.match?(/cron/i) ||
      line.match?(/EXTENSION.*(pg_cron|azure|pgaadauth)/i)
  end

  File.write(toc_list, filtered_lines.join)
  toc_list
end

def replace_user_passwords
  # Generate the encrypted password so that we can quickly update
  # all users with `update_all`

  u = User.new(password: PASSWORD_REPLACEMENT)
  u.save
  encrypted_password = u.encrypted_password

  User.all.update_all(encrypted_password: encrypted_password)
end
