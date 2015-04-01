class Invoice
  include ActiveModel::Model

  attr_accessor :id, :organization_id, :url_prefix, :filename, :name, :currency,
                :amount, :date, :attachment_url, :status, :expense_type,
                :remarks, :user_name, :email, :status, :conflict

  class << self
    def create(organization_name, url_prefix, filename, opts = {})
      params = {
          organization_name: organization_name,
          storage_key: File.join(url_prefix.gsub('${filename}', ''), filename),
          token: opts[:user_token]
      }

      begin
        new(id: KuluService::API.new.create_invoice(params))
      rescue HTTPService::Error => e
        errors.add(:base, e.message)
      end
    end

    def list(organization_name, options = {})
      begin
        PaginatedInvoices.new(KuluService::API.new.list_invoices(options.merge(organization_name: organization_name)))
      rescue HTTPService::Error => e
        errors.add(:base, e.message)
      end
    end

    def find(organization_name, id, token)
      begin
        new(KuluService::API.new.find_invoice({organization_name: organization_name, id: id, token: token}))
      rescue HTTPService::Error => e
        errors.add(:base, e.message)
      end
    end

    def update(organization_name, id, params, token)
      auth_params = {organization_name: organization_name, id: id, token: token}
      params_with_date = params.merge(date: Date.parse(params[:date]).iso8601) if params[:date]
      new(KuluService::API.new.update_invoice(auth_params, params_with_date || params))
    end

    def destroy(organization_name, id, token)
      KuluService::API.new.delete_invoice(organization_name, id, token)
    end
  end

  def decorate
    InvoiceDecorator.new(self)
    end
end
