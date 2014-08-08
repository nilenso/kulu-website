class HomeController < ApplicationController
  def dashboard
    @pre_signed_post = KuluAWS.new.presigned_post
    @invoice = Invoice.new(@pre_signed_post.key)
  end
end
