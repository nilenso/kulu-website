class Invoice
  include ActiveModel::Model

  attr_reader :errors
  attr_accessor :url_prefix, :filename, :invoice_id

  class << self
    def create(url_prefix, filename)
      object = new(url_prefix: url_prefix, filename: filename)

      begin
        object.invoice_id = KuluService::API.new.create_invoice(object.storage_key)
      rescue HTTPService::Error => e
        object.errors.merge!({base: e.message})
      end

      object
    end

    def all
      KuluService::API.new.all_invoices
    end
  end

  def initialize(url_prefix: '', filename: '')
    @url_prefix = url_prefix
    @filename = Pathname.new(filename).basename.to_s
    @invoice_id = nil
    @errors = {}
  end

  def storage_key
    File.join(url_prefix.gsub('${filename}', ''), filename)
  end

  def valid?
    errors.blank?
  end

  def error_messages
    errors.each_with_object([]) { |(k, v), acc| acc << "#{k.to_s.titlecase}: #{v.join(', ')}" }
  end
end
