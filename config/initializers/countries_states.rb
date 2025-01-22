begin
  COUNTRIES_STATES = YAML.safe_load_file(Rails.root.join("config/countries_states.yml"), symbolize_names: true).freeze
rescue => e
  puts "Error loading countries_states.yml: #{e.message}"
  COUNTRIES_STATES = {}.freeze
end
