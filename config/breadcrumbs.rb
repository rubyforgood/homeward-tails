crumb :root do
  link "Home", staff_dashboard_index_path
end

crumb :dashboard_pets do
  link "Pets", staff_pets_path
end

crumb :dashboard_pet do |pet|
  link pet.name, staff_pet_path(pet)
  parent :dashboard_pets
end

crumb :organization do |organization|
  link "Edit Profile", edit_staff_organization_path(organization)
end

crumb :custom_page do |custom_page|
  link "Edit Custom Page", edit_staff_custom_page_path(custom_page)
end

crumb :external_form do |external_form|
  link "External Form Submission", staff_external_form_upload_index_path
end

crumb :staff_index do
  link "Staff", staff_staff_index_path
end

crumb :default_pet_tasks_index do
  link "Default Pet Tasks", staff_default_pet_tasks_path
end

crumb :forms_index do
  link "Forms", staff_custom_form_forms_path
end

crumb :form do |form|
  link form.name, staff_custom_form_form_path(form)
  parent :forms_index
end

crumb :faqs_index do
  link "FAQs", staff_faqs_path
end

crumb :fosterers do
  link "Fosterers", staff_fosterers_path
end

crumb :adopters do
  link "Adopters", staff_adopters_path
end

crumb :fosters do
  link "Fosters", staff_manage_fosters_path
end

crumb :new_foster do
  link "New Foster", new_staff_manage_foster_path
  parent :fosters
end

crumb :edit_foster do |foster|
  link "Edit Foster", edit_staff_manage_foster_path(foster.id)
  parent :fosters
end

crumb :applications do |foster|
  link "Applications", staff_adoption_application_reviews_path
end

crumb :form_submissions do |person|
  link "Form Submissions", staff_person_form_submissions_path(person.id)
end

crumb :dashboard_applications do |application|
  link application.person.full_name, staff_adoption_application_reviews_path(application)
  parent :applications
end

crumb :new_feedback do |foster|
  link "New Feedback", feedback_index_path
end

crumb :edit_fosterer do |fosterer|
  link "Edit Fosterer", edit_staff_fosterer_path(fosterer.id)
  parent :fosterers
end

crumb :invite_fosterer do |fosterer|
  link "Invite Fosterer", new_staff_fosterer_invitation_path
  parent :fosterers
end
# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).
