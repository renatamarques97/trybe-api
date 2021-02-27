class ApplicationController < ActionController::Base
  respond_to :json
  skip_forgery_protection
end
