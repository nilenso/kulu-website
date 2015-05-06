class AdminController < ApplicationController
  before_filter :set_organization, :require_login

  def index
    render 'admin/index'
  end

  def invite
    KuluService::API.new.invite(invite_params)
    render :nothing => true
  end

  private

  def set_organization
    @organization_name = request.subdomain if Subdomain.matches?(request)
  end

  def require_login
    unless logged_in?
      flash[:error] = 'You must be logged in to access this section'
      redirect_to root_url # halts request cycle
    end
  end

  def invite_params
    params.permit(:token, :user_email, :organization_name)
  end
end
