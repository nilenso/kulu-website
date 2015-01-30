class InvoicesController < ApplicationController
  helper_method :sort_column, :sort_direction

  before_filter :require_login

  def create
    url_prefix, filename = params[:invoice].values_at(:url_prefix, :filename)
    invoice = Invoice.create(url_prefix, filename, current_user)

    if invoice.valid?
      redirect_to invoice_path(invoice.id)
    else
      render json: { error_messages: invoice.errors.full_messages }
    end
  end

  def show
    @invoice = Invoice.find(params[:id]).decorate
    @currencies = Currency.all
  end

  def update
    @invoice = Invoice.update(params[:id], params[:invoice])
    flash.notice = 'Invoice updated.'
    render json: { invoice: @invoice }
  end

  def destroy
    Invoice.destroy(params[:id])
    flash[:notice] = "Invoice deleted"
    redirect_to root_path, notice: "Invoice deleted"
  end


  def require_login
    unless logged_in?
      flash[:error] = "You must be logged in to access this section"
      redirect_to root_url # halts request cycle
    end
  end
end
