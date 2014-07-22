class HomeController < ApplicationController
  def dashboard
    @pre_signed_post = KuluAWS.new.presigned_post
  end
end
