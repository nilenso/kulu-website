class InvoicesController < ApplicationController
  def create
    url_prefix, filename = params[:invoice].values_at(:url_prefix, :filename)
    invoice = Invoice.new(url_prefix: url_prefix, filename: filename)
    invoice_id = KuluService::API.new.create_invoice(invoice.storage_key)

    redirect_to :root, notice: "#{filename} has been uploaded and will be processed. Upload ID: #{invoice_id}"
  end

  def index
    render json: KuluService::API.new.all_invoices
  end
end