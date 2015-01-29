class HomeController < ApplicationController
  def dashboard
    @pre_signed_post = KuluAWS.new.presigned_post
    @invoice = Invoice.new(url_prefix: @pre_signed_post.key)
  end

  def login
    redirect_to "#{KuluService::API::KULU_BACKEND_SERVICE_URL}/login?url=#{callback_url}"
  end

  def callback
    set_current_user_token(params[:token]) unless current_user
    redirect_to root_url
  end

  def logout
    set_current_user_token(nil)
    redirect_to "#{KuluService::API::KULU_BACKEND_SERVICE_URL}/logout?url=#{callback_url}"
  end
end
