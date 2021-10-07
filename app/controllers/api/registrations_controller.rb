class Api::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    unless request.format == :json
      render status: 406,
             json: { message: 'JSON requests only.' } and return
    end

    build_resource(sign_up_params)

    resource.save
    # yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        sign_up(resource_name, resource)

        respond_with resource, location:
          after_sign_up_path_for(resource) do |format|
          format.json do
            render json:
                    { success: true,
                      response: 'Registration successful' }
          end
        end
      end
    else
      render status: 401,
             json: { response: 'Incorrect parameters. Try again.' } and return
    end
  end
end
