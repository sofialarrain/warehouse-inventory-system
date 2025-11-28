class Users::RegistrationsController < Devise::RegistrationsController
    include JsonResponse
    respond_to :json

    private

    def respond_with(resource, _opts = {})
      if resource.persisted?
        render json: {
          message: "Signed up successfully.",
          data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
        }, status: :ok
      else
        render json: {
          message: "User couldn't be created successfully.",
          errors: resource.errors.full_messages
        }, status: :unprocessable_entity
      end
    end
end
