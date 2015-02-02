class HomeController < ApplicationController
  helper_method :sort_column, :sort_direction

  def dashboard
    @pre_signed_post = KuluAWS.new.presigned_post
    @invoice = Invoice.new(url_prefix: @pre_signed_post.key)
    @invoices = Invoice.list(params)
  end

  def login
    redirect_to "#{KuluService::API::KULU_BACKEND_SERVICE_URL}/login?url=#{callback_url}"
  end

  def callback
    set_current_user_token(params[:token]) unless current_user_token
    redirect_to root_url
  end

  def logout
    set_current_user_token(nil)
    redirect_to "#{KuluService::API::KULU_BACKEND_SERVICE_URL}/logout?url=#{callback_url}"
  end

  private

  def sort_column
    %w(name amount currency remarks date expense_type).include?((params[:sort] || "").downcase) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "desc"
  end
end
