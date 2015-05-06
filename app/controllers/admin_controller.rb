class AdminController < ApplicationController
  before_filter :set_organization, :require_login

  def index
    render 'admin/index'
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
end
