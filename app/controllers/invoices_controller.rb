class InvoicesController < ApplicationController
  def create
    url_prefix, filename = params[:invoice].values_at(:url_prefix, :filename)
    invoice = Invoice.create(url_prefix, filename)

    if invoice.valid?
      redirect_to :root,
                  notice: "#{filename} has been uploaded and will be processed. Upload ID: #{invoice.id}"
    else
      render json: { error_messages: invoice.errors.full_messages }
    end
  end

  def index
    @invoices = PaginatedInvoices.new(Invoice.list(params))
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
end
