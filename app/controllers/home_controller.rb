class HomeController < ApplicationController
  before_filter :set_organization
  helper_method :sort_column, :sort_direction

  def dashboard
    @pre_signed_post = KuluAWS.new.presigned_post

    if logged_in? and @organization_name.present?
      @invoice = Invoice.new(url_prefix: @pre_signed_post.key)
      params[:token] = current_user_token

      begin
        @invoices = Invoice.list(@organization_name, request_params)
      rescue HTTPService::ClientError
        logout
      end
    end

    if !logged_in? and @organization_name.blank?
      render 'home/landing'
    end
  end

  def login
    if request.subdomain == 'www'
      render 'home/signin'
    else
      render 'home/login'
    end
  end

  def auth
    begin
      auth_params = login_params.merge(team_name: @organization_name)
      set_current_user_token(KuluService::API.new.login(auth_params)['token']) unless current_user_token
      redirect_to root_url(subdomain: @organization_name)
    rescue HTTPService::Error
      redirect_to team_signin_url(subdomain: @organization_name)
    end

  end

  def team_signin
    if @organization_name.present?
      render 'home/login'
    else
      render 'home/signin'
    end
  end

  def signin
    redirect_to root_url(subdomain: login_params[:team_name]) + 'login'
  end

  def signup
    begin
      KuluService::API.new.signup(signup_params)
      redirect_to root_url(subdomain: signup_params[:name])
    rescue HTTPService::Error
      redirect_to root_url
    end
  end

  def logout
    KuluService::API.new.logout(token: current_user_token)
    session[:current_user_token] = nil if current_user_token
    redirect_to root_url(subdomain: 'www')
  end

  def forgot_password
    render 'home/forgot_password'
  end

  def forgot
    KuluService::API.new.forgot(forgot_password_params)
    render 'home/signin'
  end

  def verify_password
    @token   = params[:token]
    @user_email = params[:user_email]
    KuluService::API.new.verify_password(verify_password_params)
    render 'home/update_password'
  end

  def update_password
    KuluService::API.new.update_password(update_password_params)
    render 'home/signin'
  end

  private

  def set_organization
    @organization_name = request.subdomain if Subdomain.matches?(request)
  end

  def sort_column
    %w(name amount currency remarks date expense_type status conflict).include?((params[:sort] || '').downcase) ? params[:sort] : 'created_at'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : 'desc'
  end

  def login_params
    params.permit(:team_name, :user_email, :password)
  end

  def signup_params
    params.permit(:name, :user_email, :user_name, :password, :confirm)
  end

  def forgot_password_params
    params.permit(:organization_name, :user_email)
  end

  def verify_password_params
    params.permit(:token, :user_email)
  end

  def update_password_params
    params.permit(:password, :confirm, :user_email, :token)
  end

  def request_params
    params.permit(:order, :direction, :per_page, :page, :token)
  end
end
