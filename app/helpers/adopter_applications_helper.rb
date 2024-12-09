module AdopterApplicationsHelper
    def link_to_application?(application, user)
        application.status != 'adoption_made' || user.staff?(Current.organization)
    end
end
