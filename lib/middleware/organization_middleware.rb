class OrganizationMiddleware
  def initialize(app)
    @app = app
  end

  #
  # This middleware properly allows setting the tenant via the path
  # See https://gorails.com/episodes/rails-active-support-current-attributes for more
  # information on how this works.
  #
  def call(env)
    # Fetches the organization slug and request path from the request
    _, organization_slug, request_path = (env["REQUEST_PATH"] || env["PATH_INFO"]).split("/", 3)

    # Used to set the tenant in the controller
    Current.organization = Organization.find_by(slug: organization_slug)

    if Current.organization.present?
      #
      # This is the magic that allows the tenant to be set via the path
      #
      # Append the organization slug to every path generated in Rails
      env["SCRIPT_NAME"] = "/#{organization_slug}"

      # Set the `env` so Rails knows the process the request without the organization slug
      # included
      env["PATH_INFO"] = "/#{request_path}"
      env["REQUEST_PATH"] = "/#{request_path}"
      env["REQUEST_URI"] = "/#{request_path}"
    end

    # Continue processing the request with the updated
    # `env` as if the organization slug was not included but
    # included in the `Current.tenant` variable accessible
    # throughout the stack
    status, headers, body = @app.call(env)
    [status, headers, body]
  end
end
