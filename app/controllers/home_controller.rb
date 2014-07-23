class HomeController < ApplicationController
  def dashboard
    @pre_signed_post = KuluAWS.new.presigned_post
    @invoice = Invoice.new
    @invoice.url_prefix = @pre_signed_post.key
  end
end
