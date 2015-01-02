class InvoicesController < ApplicationController
  helper_method :sort_column, :sort_direction

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
    @invoices = Invoice.list(params)
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
    redirect_to invoices_path, notice: "Invoice deleted"
  end

  private

  def sort_column
    %w(name amount currency remarks date).include?((params[:sort] || "").downcase) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "desc"
  end
end
