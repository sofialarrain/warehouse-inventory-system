module JsonResponse
    extend ActiveSupport::Concern

    private

    def serialize(resource)
      if resource.respond_to?(:each)
        UserSerializer.new(resource).serializable_hash[:data].map { |item| item[:attributes] }
      else
        UserSerializer.new(resource).serializable_hash[:data][:attributes]
      end
    end

    def render_success(data: nil, message: "Success", status: :ok)
      render json: { message: message, data: data }, status: status
    end

    def render_error(errors: [], message: "Error", status: :unprocessable_entity)
      render json: { message: message, errors: Array(errors) }, status: status
    end
end
