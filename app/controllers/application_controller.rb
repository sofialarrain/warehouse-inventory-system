class ApplicationController < ActionController::API
    include JsonResponse
    before_action :authenticate_user!
end
