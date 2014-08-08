class Invoice
  include ActiveModel::Model

  attr_reader :errors
  attr_accessor :url_prefix, :filename, :invoice_id

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

    def list(page)
      KuluService::API.new.list_invoices(page)
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
