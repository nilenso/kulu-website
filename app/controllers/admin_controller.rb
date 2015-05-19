class AdminController < ApplicationController
  before_filter :set_organization, :require_login

  def index
    render 'admin/index'
  end

  def invite
    begin
      KuluService::API.new.invite(invite_params)
      flash.notice = "Sent an invite to #{invite_params[:user_email]}"
      render :nothing => true
    rescue HTTPService::ClientError => e
      flash.alert = "#{invite_params[:user_email]} is already a member"
      render json: e.to_json, status: 400 and return
    end
  end


  def users
    begin
      render json: KuluService::API.new.users(users_params).to_json
    rescue HTTPService::ClientError => e
      flash.alert = "#{e}"
      render json: e.to_json, status: 400 and return
    end
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

  def users_params
    params.permit(:token, :organization_name)
  end
end
