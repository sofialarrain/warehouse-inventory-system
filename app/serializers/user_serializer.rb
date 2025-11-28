class UserSerializer
    include JSONAPI::Serializer

    attributes :id, :email, :full_name, :role, :created_at
end
