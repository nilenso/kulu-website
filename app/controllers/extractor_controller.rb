class ExtractorController < ApplicationController
  def index
    begin
      index_params.merge!(token: current_extractor_user_token)
      @invoices = PaginatedInvoices.new(KuluService::ExtractorAPI.new.list_invoices(index_params))
    rescue HTTPService::ClientError
      logout
    end
  end

  def show
    begin
      Invoice.new(KuluService::ExtractorAPI.new.find_invoice(id: id, token: current_extractor_user_token))
    rescue HTTPService::Error
      logout
    end
  end

  def update
    params.merge!(date: Date.parse(params[:date]).iso8601) if params[:date]
    params.merge!(token: current_extractor_user_token)
    Invoice.new(KuluService::ExtractorAPI.new.update_invoice(params[:invoice]))
  end

  def authorize
    begin
      unless current_extractor_user_token
        set_current_extractor_user_token(KuluService::ExtractorAPI.new.login(login_params)['token'])
      end

      redirect_to root_url
    rescue HTTPService::Error
      redirect_to login_extractor_index
    end
  end

  private

  def set_current_extractor_user_token(token)
    session[:current_extractor_user_token] = token
  end

  def current_extractor_user_token
    @current_extractor_user_token ||= session[:current_extractor_user_token]
  end

  def index_params
    params.permit(:order, :direction, :per_page, :page)
  end

  def login_params
    params.permit(:user_email, :password)
  end
end

