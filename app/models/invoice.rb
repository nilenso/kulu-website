class Invoice
  include ActiveModel::Model

  attr_reader :errors
  attr_accessor :url_prefix, :filename, :invoice_id

  class PaginatedInvoices < Array
    def initialize(raw_data)
      @raw_data = raw_data
    end

    def enrich
      invoices = @raw_data["items"].map {|i| OpenStruct.new(i)}

      pagination_keys = %w{page per_page total_pages total_count}
      page, limit, total_pages, total_count =
        @raw_data["meta"].values_at(*pagination_keys)
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
      object = new(url_prefix, filename)

      begin
        object.invoice_id = KuluService::API.new.create_invoice(object.storage_key)
      rescue HTTPService::Error => e
        object.errors.add(:base, e.message)
      end

      object
    end

    def all
      raw_data = KuluService::API.new.all_invoices
      PaginatedInvoices.new(raw_data).enrich
    end
  end

  def initialize(url_prefix, filename = '')
    @url_prefix = url_prefix
    @filename = Pathname.new(filename).basename.to_s
    @errors = ActiveModel::Errors.new(self)
  end

  def storage_key
    File.join(url_prefix.gsub('${filename}', ''), filename)
  end

  def valid?
    errors.blank?
  end
end
