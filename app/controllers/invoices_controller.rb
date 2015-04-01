class InvoicesController < ApplicationController
  before_filter :set_organization, :require_login

  def create
    url_prefix, filename = params[:invoice].values_at(:url_prefix, :filename)
    invoice = Invoice.create(@organization_name, url_prefix, filename, user_token: current_user_token)

    if invoice.valid?
      redirect_to invoice_path(invoice.id)
    else
      render json: {error_messages: invoice.errors.full_messages}
    end
  end

  def show
    @invoice = Invoice.find(@organization_name, params[:id], current_user_token).decorate
    @currencies = Currency.all
    @invoice_states = KuluService::API.new.list_of_states({organization_name: @organization_name,
                                                           token: current_user_token})
    @invoices = Invoices.next_and_prev_invoices(params.merge({organization_name: @organization_name,
                                                              token: current_user_token}))
  end

  def update
    @invoice = Invoice.update(@organization_name, params[:id], params[:invoice], current_user_token)
    flash.notice = 'Invoice updated.'
    render json: {invoice: @invoice}
  end

  def destroy
    Invoice.destroy(@organization_name, params[:id], current_user_token)
    flash[:notice] = 'Invoice deleted'
    redirect_to root_path, notice: 'Invoice deleted'
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
