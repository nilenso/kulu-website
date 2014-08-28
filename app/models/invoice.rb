class Invoice
  include ActiveModel::Model

  attr_accessor :id, :url_prefix, :filename, :name, :currency,
                :amount, :date, :attachment_url, :status

  class << self
    def create(url_prefix, filename)
      object = new(url_prefix: url_prefix, filename: Pathname.new(filename).basename.to_s)

      begin
        object.id = KuluService::API.new.create_invoice(object.storage_key)
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
          attachment_url: raw_data['attachment_url'])
      o.date = raw_data['date'] if raw_data['date']
      o
    end

    def update(id, params)
      raw_data = KuluService::API.new.update_invoice(id, params)
      o = new(id: raw_data['id'],
          name: raw_data['name'],
          amount: raw_data['amount'],
          currency: raw_data['currency'])
      o.date = raw_data['date'] if raw_data['date']
      o
    end
  end

  def storage_key
    File.join(url_prefix.gsub('${filename}', ''), filename)
  end

  def decorate
    InvoiceDecorator.new(self)
  end
end
