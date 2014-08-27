class Invoice
  include ActiveModel::Model

  attr_accessor :url_prefix, :filename, :invoice_id, :name, :currency,
                :amount, :date, :attachment_url

  class PaginatedInvoices < Array
    def initialize(raw_data)
      @raw_data = raw_data
    end

    def enrich
      invoices = @raw_data['items'].map {|i| OpenStruct.new(i)}

      pagination_keys = %w{page per_page total_pages total_count}
      page, limit, total_pages, total_count =
        @raw_data['meta'].values_at(*pagination_keys)
      offset = (page - 1) * limit

      Kaminari::PaginatableArray.new(invoices, total_count: total_count).tap do |arr|
        arr.singleton_class.class_eval do
          # FIXME: instead of dynamically defining these methods, we
          # should find a way to define them once.
          define_method :current_page do
            page
          end
          define_method :total_pages do
            total_pages
          end
          define_method :limit_value do
            limit
          end
          define_method :offset_value do
            offset
          end
          define_method :last_page? do
            page == total_pages
          end
        end
      end
    end
  end

  class << self
    def create(url_prefix, filename)
      object = new(url_prefix: url_prefix, filename: Pathname.new(filename).basename.to_s)

      begin
        object.invoice_id = KuluService::API.new.create_invoice(object.storage_key)
      rescue HTTPService::Error => e
        object.errors.add(:base, e.message)
      end

      object
    end

    def list(options = {})
      raw_data = KuluService::API.new.list_invoices(options)
      PaginatedInvoices.new(raw_data).enrich
    end

    def find(invoice_id)
      raw_data = KuluService::API.new.find_invoice(invoice_id)
      new(invoice_id: raw_data['id'],
          name: raw_data['name'],
          amount: raw_data['amount'],
          currency: raw_data['currency'],
          attachment_url: raw_data['attachment_url']
          ).tap do |i|
             i.date = Date.parse(raw_data['date']) if raw_data['date']
          end
    end

    def update(invoice_id, params)
      raw_data = KuluService::API.new.update_invoice(invoice_id, params)
      new(invoice_id: raw_data['id'],
          name: raw_data['name'],
          amount: raw_data['amount'],
          currency: raw_data['currency']
      ).tap do |i|
        i.date = Date.parse(raw_data['date']) if raw_data['date']
      end
    end
  end

  def storage_key
    File.join(url_prefix.gsub('${filename}', ''), filename)
  end

  def decorate
    InvoiceDecorator.new(self)
  end
end
