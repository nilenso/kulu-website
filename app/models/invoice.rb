class Invoice
  include ActiveModel::Model

  attr_accessor :id, :organization_id, :url_prefix, :filename, :name, :currency,
                :amount, :date, :attachment_url, :status, :expense_type,
                :remarks, :user_name, :email, :status, :conflict, :category_name, :category_id

  class << self
    def create(options)
      options[:invoice].merge!(storage_key: File.join(options[:invoice][:url_prefix].gsub('${filename}', ''),
                                                      options[:invoice][:filename])).except(:url_prefix, :filename)
      begin
        new(id: KuluService::API.new.create_invoice(options))
      rescue HTTPService::Error => e
        errors.add(:base, e.message)
      end
    end

    def list(options)
      PaginatedInvoices.new(KuluService::API.new.list_invoices(options))
    end

    def find(options)
      begin
        new(KuluService::API.new.find_invoice(options))
      rescue HTTPService::Error => e
        errors.add(:base, e.message)
      end
    end

    def update(options)
      date = options[:invoice][:date]
      options[:invoice].merge!(date: Date.parse(date).iso8601) if date
      new(KuluService::API.new.update_invoice(options))
    end

    def destroy(options)
      KuluService::API.new.delete_invoice(options)
    end
  end

  def decorate
    InvoiceDecorator.new(self)
  end
end
