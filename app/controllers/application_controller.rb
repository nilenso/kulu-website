require 'http_service/error'

class ApplicationController < ActionController::Base
  before_filter :set_aws_presigned_post
  protect_from_forgery with: :exception

  rescue_from(HTTPService::ClientError) do |exception|
    raise ActionController::RoutingError.new('Not Found') if exception.http_status == 404
  end

  def current_user_token
    @current_user_token ||= session[:current_user_token]
  end

  def set_current_user_token(token)
    session[:current_user_token] = token
  end

  def logged_in?
    current_user_token.present?
  end

  def set_organization
    @organization_name = request.subdomain if Subdomain.matches?(request)
  end

  def require_login
    unless logged_in?
      if @organization_name.present?
        render 'static_pages/not_logged_in'
      else
        render 'home/signin'
      end
    end
  end

  def set_aws_presigned_post
    @pre_signed_post = KuluAWS.new.presigned_post
    @invoice = Invoice.new(url_prefix: @pre_signed_post.key)
  end

  helper_method :current_user_token, :logged_in?
end
