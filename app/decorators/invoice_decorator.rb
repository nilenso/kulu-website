class InvoiceDecorator < Draper::Decorator
  delegate_all

  def attachment_url
    object.attachment_url || helpers.asset_path('placeholder-portrait-450x600.jpg')
  end
end
