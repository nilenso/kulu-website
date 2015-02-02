class Invoice
  include ActiveModel::Model

  attr_accessor :id, :url_prefix, :filename, :name, :currency,
                :amount, :date, :attachment_url, :status, :expense_type,
                :remarks, :user_name, :email

  class << self
    def create(url_prefix, filename, opts = {})
      object = new(url_prefix: url_prefix, filename: Pathname.new(filename).basename.to_s)

      begin
        object.id = KuluService::API.new.create_invoice(object.storage_key, opts[:user_token])
      rescue HTTPService::Error => e
        object.errors.add(:base, e.message)
      end

      object
    end

    def list(options = {})
      PaginatedInvoices.new(KuluService::API.new.list_invoices(options))
    end

    def find(id)
      raw_data = KuluService::API.new.find_invoice(id)
      o = new(id: raw_data['id'],
          name: raw_data['name'],
          amount: raw_data['amount'],
          currency: raw_data['currency'],
          attachment_url: raw_data['attachment_url'],
          expense_type: raw_data['expense_type'],
          remarks: raw_data['remarks'])
      o.date = raw_data['date'] if raw_data['date']
      o
    end

    def update(id, params)
      params_with_date = params.merge(date: Date.parse(params[:date]).iso8601) if params[:date]
      raw_data = KuluService::API.new.update_invoice(id, params_with_date || params)
      o = new(id: raw_data['id'],
          name: raw_data['name'],
          amount: raw_data['amount'],
          currency: raw_data['currency'],
          expense_type: raw_data['expense_type'],
          remarks: raw_data['remarks'])
      o.date = raw_data['date'] if raw_data['date']
      o
    end

    def destroy(id)
      KuluService::API.new.delete_invoice(id)
    end
  end

  def storage_key
    File.join(url_prefix.gsub('${filename}', ''), filename)
  end

  def decorate
    InvoiceDecorator.new(self)
  end
end
