require 'http_service/error'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from(HTTPService::ClientError) do |exception|
    raise ActionController::RoutingError.new('Not Found') if exception.http_status == 404
  end

  def current_user
    @current_user ||= session[:current_user_token]
  end

  def set_current_user_token(token)
    session[:current_user_token] = token
  end

  def logged_in?
    current_user.present?
  end 
  
  helper_method :current_user, :logged_in?
end
